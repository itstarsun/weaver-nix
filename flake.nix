{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./flake-module.nix
      ];

      systems = [
        "x86_64-linux"
      ];

      flake.flakeModule = import ./flake-module.nix;

      perSystem = { config, ... }: {
        packages.weaver = config.weaver.package;
        packages.weaver-gke = config.weaver.gke.package;
      };
    };
}
