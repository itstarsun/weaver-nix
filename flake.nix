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

          nodes.machine = { pkgs, ... }: {
            imports = [
              inputs.self.nixosModules.weaver
            ];

            services.weaver = {
              enable = true;

              dashboard.enable = true;

              deployments = {
                invalid = {
                  binary = "${pkgs.hello}/bin/hello";
                };
              };
            };
          };

          testScript = ''
            machine.start()
            machine.wait_for_unit("default.target")

            machine.wait_for_unit("weaver-dashboard.service")
            machine.succeed("curl http://localhost:27333")

            # TODO: Test invalid deployment?
          '';
        };
      };
    };
}
