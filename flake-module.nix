{ lib, flake-parts-lib, ... }:
let
  inherit (flake-parts-lib) mkPerSystemOption;
  inherit (lib) mkOption types;
in
{
  options = {
    perSystem = mkPerSystemOption ({ pkgs, ... }: {
      options.weaver = {
        package = mkOption {
          type = types.package;
          default = pkgs.callPackage ./default.nix { };
        };

        gke.package = mkOption {
          type = types.package;
          default = pkgs.callPackage ./gke.nix { };
        };
      };
    });
  };
}
