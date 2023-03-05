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

              hello-delayed = pkgs.writeShellScript "hello-delayed" ''
                sleep 3 && ${getExe hello}
              '';
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
                    args = [ "these" "are" "command" "line" "arguments" ];
                    env = {
                      PUT = "your";
                      ENV = "vars";
                      HERE = "";
                    };
                    colocate = [
                      [ "main/Rock" "main/Paper" "main/Scissors" ]
                      [ "github.com/example/sandy/PeanutButter" "github.com/example/sandy/Jelly" ]
                    ];
                    rollout = "1m";
                  };

                  hello-delayed = {
                    binary = hello-delayed;
                  };
                };
              };
            };

          # TODO: Test that the deployment actually appear in the dashboard.
          # TODO: Manually restarting weaver-deployment-hello-delayed shouldn't be necessary.
          testScript = ''
            machine.start()
            machine.wait_for_unit("default.target")

            machine.wait_for_unit("weaver-dashboard.service")
            machine.wait_until_succeeds("curl -s http://localhost:27333")

            machine.wait_for_unit("weaver-deployment-hello.service")
            machine.wait_until_succeeds("curl -s http://localhost:8080")

            machine.systemctl("stop weaver-deployment-hello.service")
            machine.systemctl("restart weaver-deployment-hello-delayed.service")

            machine.wait_for_unit("weaver-deployment-hello-delayed.service")
            machine.wait_until_succeeds("curl -s http://localhost:8080")
          '';
        };
      };
    };
}
