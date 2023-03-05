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
        ./nixos-module.nix
      ];

      systems = [
        "x86_64-linux"
      ];

      flake.flakeModule = import ./flake-module.nix;

      perSystem = { config, pkgs, ... }: {
        packages.weaver = config.weaver.package;
        packages.weaver-gke = config.weaver.gke.package;

        checks.weaver = pkgs.nixosTest {
          name = "weaver";

          nodes.machine = { lib, pkgs, ... }:
            let
              inherit (lib) getExe;

              hello = pkgs.callPackage ./tests/hello { };
            in
            {
              imports = [
                inputs.self.nixosModules.weaver
              ];

              services.weaver = {
                enable = true;

                dashboard.enable = true;

                deployments = {
                  hello = {
                    binary = getExe hello;
                  };
                };
              };
            };

          # TODO: Test that the deployment actually appear in the dashboard.
          # TODO: Test failure deployment?
          testScript = ''
            machine.start()
            machine.wait_for_unit("default.target")

            machine.wait_for_unit("weaver-dashboard.service")
            machine.wait_until_succeeds("curl -s http://localhost:27333")

            machine.wait_for_unit("weaver-deployment-hello.service")
            machine.wait_until_succeeds("curl -s http://localhost:8080")
          '';
        };
      };
    };
}
