{ moduleWithSystem, ... }:

{
  flake = {
    nixosModules.weaver = moduleWithSystem (perSystem @ { config }: { config, lib, pkgs, ... }:
      with lib;

      let
        cfg = config.services.weaver;

        mkService = args:
          recursiveUpdate
            {
              wantedBy = [ "multi-user.target" ];
              after = [ "network.target" ];
              serviceConfig = {
                Restart = "always";
                RestartSec = "10s";
                User = cfg.user;
                Group = cfg.group;
              };
            }
            args;

        mkDeploymentService = name: deployment:
          let
            configfile = pkgs.writeText "weaver.toml" ''
              [serviceweaver]
              name = "${name}"
              binary = "${deployment.binary}"
            '';
          in
          mkService {
            serviceConfig.ExecStart = "${cfg.package}/bin/weaver multi deploy ${configfile}";
          };
      in

      {
        options = {
          services.weaver = {
            enable = mkEnableOption "weaver";

            package = mkOption {
              type = types.package;
              default = perSystem.config.weaver.package;
            };

            user = mkOption {
              type = types.str;
              default = "weaver";
            };

            group = mkOption {
              type = types.str;
              default = "weaver";
            };

            dashboard = {
              enable = mkEnableOption "weaver dashboard";

              host = mkOption {
                type = types.str;
                default = "localhost";
              };

              port = mkOption {
                type = types.port;
                default = 27333;
              };
            };

            deployments = mkOption {
              type = types.attrsOf
                (types.submodule {
                  options = {
                    binary = mkOption {
                      type = types.str;
                      description = lib.mdDoc ''
                        Compiled Service Weaver application. The binary path, if not absolute,
                        should be relative to the directory that contains the config file.
                      '';
                    };

                    args = mkOption {
                      type = types.listOf types.str;
                      default = [ ];
                      example = [ "these" "are" "command" "line" "arguments" ];
                      description = lib.mdDoc ''
                        Command line arguments passed to the binary.
                      '';
                    };

                    env = mkOption {
                      type = types.attrsOf types.str;
                      default = { };
                      example = {
                        PUT = "your";
                        ENV = "vars";
                        HERE = "";
                      };
                      description = lib.mdDoc ''
                        Environment variables that are set before the binary executes.
                      '';
                    };

                    colocate = mkOption {
                      type = types.listOf (types.listOf types.str);
                      default = [ ];
                      example = [
                        [ "main/Rock" "main/Paper" "main/Scissors" ]
                        [ "github.com/example/sandy/PeanutButter" "github.com/example/sandy/Jelly" ]
                      ];
                      description = lib.mdDoc ''
                        List of colocation groups. When two components in the same colocation group are deployed,
                        they are deployed in the same OS process, where all method calls between them are performed
                        as regular Go method calls. To avoid ambiguity, components must be prefixed by their full package path
                        (e.g., github.com/example/sandy/). Note that the full package path of the main package in an executable is main.
                      '';
                    };

                    rollout = mkOption {
                      type = types.nullOr types.str;
                      default = null;
                      example = "1m";
                      description = lib.mdDoc ''
                        How long it will take to roll out a new version of the application.
                        See the GKE Deployments section for more information on rollouts.
                      '';
                    };
                  };
                });
              default = { };
            };
          };
        };

        config = mkIf cfg.enable (mkMerge [
          {
            users.users.weaver = mkIf (cfg.user == "weaver") {
              group = cfg.group;
              home = "/var/lib/weaver";
              createHome = true;
              isSystemUser = true;
            };

            users.groups.weaver = mkIf (cfg.group == "weaver") { };

            systemd.services = mapAttrs'
              (name: deployment:
                nameValuePair "weaver-deployment-${name}" (mkDeploymentService name deployment)
              )
              cfg.deployments;
          }

          (mkIf cfg.dashboard.enable {
            systemd.services.weaver-dashboard = mkService {
              serviceConfig.ExecStart = "${cfg.package}/bin/weaver multi dashboard --host ${cfg.dashboard.host} --port ${toString cfg.dashboard.port}";
            };
          })
        ]);
      }
    );
  };
}
