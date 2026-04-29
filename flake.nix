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

        # nix develop [#...]
        devShells = {
          default = pkgs.mkShell {
            shellHook = pkgs.shellhook.ref;
            packages = with pkgs; [
              # node
              nodejs_24

              # lint
              biome
              nixd

              # format
              treefmt
              prettier
              nixfmt

              # util
              bumper
            ];
          };

          bump = pkgs.mkShell {
            packages = with pkgs; [
              bumper
            ];
          };

          release = pkgs.mkShell {
            packages = with pkgs; [
              flake-release # github
              nodejs_24 # npm publish
            ];
          };

          update = pkgs.mkShell {
            packages = with pkgs; [
              renovate
              nodejs_24 # npm install
            ];
          };

          vulnerable = pkgs.mkShell {
            packages = with pkgs; [
              flake-checker # nix
              zizmor # actions
              nodejs_24 # npm audit
            ];
          };
        };

        # nix run [#...]
        apps = pkgs.mkApps {
          default = "npm run dev";
        };

        # nix build [#...]
        packages = {
          default = pkgs.buildNpmPackage (
            final: with pkgs.lib; {
              pname = "node-template";
              version = "0.6.10";

              src = fileset.toSource {
                root = ./.;
                fileset = fileset.unions [
                  ./.npmrc
                  ./package.json
                  ./package-lock.json
                  ./rolldown.config.ts
                  ./tsconfig.json
                  ./src
                  ./tests
                ];
              };

              nodejs = pkgs.nodejs_24;
              npmConfigHook = pkgs.importNpmLock.npmConfigHook;
              npmDeps = pkgs.importNpmLock {
                npmRoot = final.src;
              };

              meta = {
                mainProgram = "node-template";
                description = "A template for node.js projects";
                license = licenses.mit;
                platforms = platforms.all;
                badPlatforms = [ systems.inspect.platformPatterns.isStatic ];
                homepage = "https://github.com/spotdemo4/node-template";
                changelog = "https://github.com/spotdemo4/node-template/releases/tag/v${final.version}";
              };
            }
          );
        };

        # nix build #images.[...]
        images = {
          default = pkgs.mkImage {
            src = self.packages.${system}.default;
          };
        };

        # nix build #appimages.[...]
        appimages = {
          default = pkgs.mkAppImage {
            src = self.packages.${system}.default;
          };
        };

        # nix fmt
        formatter = pkgs.treefmt.withConfig {
          configFile = ./treefmt.toml;
          runtimeInputs = with pkgs; [
            prettier
            nixfmt
            biome
          ];
        };

        # nix flake check
        checks = pkgs.mkChecks {
          prettier = {
            root = ./.;
            filter = file: file.hasExt "yaml" || file.hasExt "md";
            packages = with pkgs; [
              prettier
            ];
            forEach = ''
              prettier --check "$file"
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

          actions = {
            root = ./.;
            files = [
              ./action.yaml
              ./.github/workflows
            ];
            filter = file: file.hasExt "yaml";
            packages = with pkgs; [
              action-validator
              zizmor
            ];
            forEach = ''
              action-validator "$file"
              zizmor --offline "$file"
            '';
          };

          renovate = {
            root = ./.github;
            files = ./.github/renovate.json;
            packages = with pkgs; [
              renovate
            ];
            script = ''
              renovate-config-validator renovate.json
            '';
          };

          biome = {
            root = ./.;
            filter = file: file.hasExt "ts" || file.hasExt "js" || file.hasExt "json";
            include = ./.gitignore;
            packages = with pkgs; [
              biome
            ];
            script = ''
              biome ci
            '';
          };

          node = {
            src = self.packages.${system}.default;
            script = ''
              npm test
            '';
          };
        };
      }
    );
}
