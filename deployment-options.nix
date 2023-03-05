{ config, lib, ... }:

with lib;

{
  options = {
    binary = mkOption {
      type = types.path;
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

    gke = mkOption {
      type = types.nullOr (types.submodule {
        options = {
          project = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "my-google-cloud-project";
            description = lib.mdDoc ''
              Name of the Google Cloud Project in which to deploy the Service Weaver application.
              If absent, the currently active project is used (i.e. gcloud config get-value project)
            '';
          };

          account = mkOption {
            type = types.str;
            example = "my_account@gmail.com";
            description = lib.mdDoc ''
              Google Cloud account used to deploy the Service Weaver application.
              If absent, the currently active account is used (i.e. gcloud config get-value account).
            '';
          };

          regions = mkOption {
            type = types.listOf types.str;
            default = [ ];
            example = [ "us-west1" "us-east1" ];
            description = lib.mdDoc ''
              Regions in which the Service Weaver application should be deployed.
              Defaults to ["us-west1"].
            '';
          };

          publicListener = mkOption {
            type = types.listOf (types.submodule {
              options = {
                name = mkOption {
                  type = types.str;
                };

                hostname = mkOption {
                  type = types.str;
                };
              };
            });
            default = [ ];
            example = [
              { name = "cat"; hostname = "cat.com"; }
              { name = "hat"; hostname = "hat.gg"; }
            ];
            description = lib.mdDoc ''
              The application's public listeners along with their corresponding hostnames.
            '';
          };
        };
      });
      default = null;
    };
  };
}
