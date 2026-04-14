{
  description = "node.js template";

  nixConfig = {
    extra-substituters = [
      "https://nix.trev.zip"
    ];
    extra-trusted-public-keys = [
      "trev:I39N/EsnHkvfmsbx8RUW+ia5dOzojTQNCTzKYij1chU="
    ];
  };

  inputs = {
    systems.url = "github:spotdemo4/systems";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    trev = {
      url = "github:spotdemo4/nur";
      inputs.systems.follows = "systems";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      trev,
      ...
    }:
    trev.libs.mkFlake (
      system: pkgs: {
        devShells = {
          default = pkgs.mkShell {
            shellHook = pkgs.shellhook.ref;
            packages = with pkgs; [
              # node
              nodejs_24

              # lint
              biome

              # format
              nixfmt
              prettier

              # util
              bumper
              flake-release
            ];
          };

          bump = pkgs.mkShell {
            packages = with pkgs; [
              bumper
            ];
          };

          release = pkgs.mkShell {
            packages = with pkgs; [
              flake-release
            ];
          };

          update = pkgs.mkShell {
            packages = with pkgs; [
              renovate
              nodejs_24 # npm i
            ];
          };

          vulnerable = pkgs.mkShell {
            packages = with pkgs; [
              nodejs_24 # node
              flake-checker # nix
              octoscan # actions
            ];
          };
        };

        checks = pkgs.mkChecks {
          node = {
            src = self.packages.${system}.default;
            packages = with pkgs; [
              biome
            ];
            script = ''
              biome ci
            '';
          };

          actions = {
            root = ./.;
            fileset = ./.github/workflows;
            packages = with pkgs; [
              action-validator
              octoscan
            ];
            forEach = ''
              action-validator "$file"
              octoscan scan "$file"
            '';
          };

          renovate = {
            root = ./.github;
            fileset = ./.github/renovate.json;
            packages = with pkgs; [
              renovate
            ];
            script = ''
              renovate-config-validator renovate.json
            '';
          };

          nix = {
            root = ./.;
            filter = file: file.hasExt "nix";
            packages = with pkgs; [
              nixfmt
            ];
            forEach = ''
              nixfmt --check "$file"
            '';
          };

          prettier = {
            root = ./.;
            filter = file: file.hasExt "yaml" || file.hasExt "json" || file.hasExt "md";
            packages = with pkgs; [
              prettier
            ];
            forEach = ''
              prettier --check "$file"
            '';
          };
        };

        apps = pkgs.mkApps {
          dev = "npm run dev";
        };

        packages = with pkgs.lib; {
          default = pkgs.buildNpmPackage (finalAttrs: {
            pname = "node-template";
            version = "0.6.1";

            src = fileset.toSource {
              root = ./.;
              fileset = fileset.difference ./. (
                fileset.unions [
                  ./.github
                  ./.vscode
                  ./flake.nix
                  ./flake.lock
                ]
              );
            };

            nodejs = pkgs.nodejs_24;
            npmConfigHook = pkgs.importNpmLock.npmConfigHook;
            npmDeps = pkgs.importNpmLock {
              npmRoot = finalAttrs.src;
            };

            nativeBuildInputs = with pkgs; [
              makeWrapper
            ];

            meta = {
              mainProgram = "node-template";
              description = "A template for node.js projects.";
              license = licenses.mit;
              platforms = platforms.all;
              homepage = "https://github.com/spotdemo4/node-template";
              changelog = "https://github.com/spotdemo4/node-template/releases/tag/v${finalAttrs.version}";
            };
          });
        };

        images = {
          default = pkgs.mkImage self.packages.${system}.default {
            contents = with pkgs; [ dockerTools.caCertificates ];
          };
        };

        formatter = pkgs.nixfmt-tree;
        schemas = trev.schemas;
      }
    );
}
