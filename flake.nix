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
                sleep 3 && ${getExe hello} $@
              '';

              weaver-multi-wrapper = pkgs.writeShellScriptBin "weaver-multi-wrapper" ''
                ${config.weaver.package}/bin/weaver multi $@
              '';

              mkDeployment = binary: {
                binary = binary;
                args = [ "these" "are" "command" "line" "arguments" ];
                env = {
                  PUT = "your";
                  ENV = "vars";
                  HERE = "";
                };
                colocate = [
                  [ "github.com/itstarsun/weaver-nix/tests/hello/Service" ]
                ];
                rollout = "1m";
              };
            in
            {
              imports = [
                inputs.self.nixosModules.weaver
              ];

              virtualisation.graphics = false;

              services.weaver = {
                enable = true;

                dashboard.enable = true;

                deployer = {
                  name = "multi-wrapper";
                  package = weaver-multi-wrapper;
                };

                deployments = {
                  hello = mkDeployment (getExe hello);
                  hello-delayed = mkDeployment hello-delayed;
                };
              };
            };

          # TODO: Test that the deployment actually appear in the dashboard.
          # TODO: Manually restarting weaver-deployment-hello-delayed shouldn't be necessary.
          testScript = ''
            import json

            start_all()

            machine.wait_for_open_port(27333)
            machine.succeed("curl http://localhost:27333")

            machine.wait_for_open_port(8080)
            machine.succeed("curl http://localhost:8080")

            machine.systemctl("stop weaver-deployment-hello.service")
            machine.systemctl("restart weaver-deployment-hello-delayed.service")

            machine.wait_for_open_port(8080)
            machine.succeed("curl http://localhost:8080")

            args = json.loads(machine.succeed("curl http://localhost:8080/args"))
            assert args == ["these", "are", "command", "line", "arguments"]

            env = json.loads(machine.succeed("curl http://localhost:8080/env"))
            assert set(env).issuperset([
              ("PUT=your"),
              ("ENV=vars"),
              ("HERE="),
            ])
          '';

          meta.timeout = 120;
        };
      };
    };
}
