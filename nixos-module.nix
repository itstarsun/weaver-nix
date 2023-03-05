{ moduleWithSystem, ... }:

{
  flake = {
    nixosModules.weaver = moduleWithSystem (perSystem @ { config }: { config, lib, pkgs, ... }:
      with lib;

      let
        cfg = config.services.weaver;

        cmd = "${cfg.package}/bin/weaver ${cfg.deployer.name}";

        mkService = args:
          recursiveUpdate
            {
              wantedBy = [ "multi-user.target" ];
              after = [ "network.target" ];
              path = [
                cfg.deployer.package
              ];
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
            configfile = pkgs.writeText "weaver.toml" (''
              [serviceweaver]
              name = "${name}"
              binary = "${deployment.binary}"
            ''
            + optionalString (deployment.args != [ ]) ''
              args = ${builtins.toJSON deployment.args}
            ''
            + optionalString (deployment.env != { }) ''
              env = ${builtins.toJSON (mapAttrsToList (name: value: "${name}=${value}") deployment.env)}
            ''
            + optionalString (deployment.colocate != [ ]) ''
              colocate = ${builtins.toJSON deployment.colocate}
            ''
            + optionalString (deployment.rollout != null) ''
              rollout = ${builtins.toJSON deployment.rollout}
            '');
          in
          mkService {
            serviceConfig.ExecStart = "${cmd} deploy ${configfile}";
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

            deployer = {
              name = mkOption {
                type = types.str;
                default = "multi";
              };

              package = mkOption {
                type = types.package;
                default = perSystem.config.weaver.package;
              };
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
              type = types.attrsOf (types.submodule (import ./deployment-options.nix {
                inherit config lib;
              }));
              default = { };
            };
          };
        };

        config = mkIf cfg.enable (mkMerge [
          {
            users.users = (optionalAttrs (cfg.user == "weaver") {
              weaver = {
                group = cfg.group;
                home = "/var/lib/weaver";
                createHome = true;
                isSystemUser = true;
              };
            });

            users.groups = optionalAttrs (cfg.group == "weaver") {
              weaver = { };
            };

            systemd.services = mapAttrs'
              (name: deployment: nameValuePair "weaver-deployment-${name}"
                (mkDeploymentService name deployment)
              )
              cfg.deployments;
          }

          (mkIf cfg.dashboard.enable {
            systemd.services.weaver-dashboard = mkService {
              serviceConfig.ExecStart = "${cmd} dashboard --host ${cfg.dashboard.host} --port ${toString cfg.dashboard.port}";
            };
          })
        ]);
      }
    );
  };
}

