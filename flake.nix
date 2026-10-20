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
    trevpkgs = {
      url = "github:spotdemo4/trevpkgs";
      inputs.systems.follows = "systems";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      trevpkgs,
      ...
    }:
    trevpkgs.libs.mkFlake (
      system: pkgs: {

        # nix develop [#...]
        devShells = {
          default = pkgs.mkShell {
            shellHook = pkgs.shellhook.ref;
            packages = with pkgs; [
              # node
              nodejs_26
              oxlint
              typescript

              vscode-json-languageserver # json
              yaml-language-server # yaml
              tombi # toml
              oxfmt # format

              # nix
              nixd
              nixfmt

              # util
              treefmt
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
              flake-release
            ];
          };

          update = pkgs.mkShell {
            packages = with pkgs; [
              renovate
              nodejs_26 # npm install
            ];
          };

          vulnerable = pkgs.mkShell {
            packages = with pkgs; [
              nodejs_26 # npm audit
              flake-checker # nix
              zizmor # actions
            ];
          };
        };

        # nix build [#...]
        packages = {
          default = pkgs.buildNpmPackage (
            final: with pkgs.lib; {
              pname = "node-template";
              version = "0.11.1";

              src = fileset.toSource {
                root = ./.;
                fileset = fileset.unions [
                  ./.oxfmtrc.json
                  ./.oxlintrc.json
                  ./LICENSE
                  ./package-lock.json
                  ./package.json
                  ./README.md
                  ./src
                  ./tests
                  ./tsconfig.json
                  ./vite.config.ts
                ];
              };

              nodejs = pkgs.nodejs_26;
              npmConfigHook = pkgs.importNpmLock.npmConfigHook;
              npmDeps = pkgs.importNpmLock {
                npmRoot = final.src;
              };

              checkPhase = ''
                runHook preCheck
                npm test
                runHook postCheck
              '';

              installCheckPhase = ''
                runHook preInstallCheck
                test "$("$out/bin/node-template")" = "Hello, world!"
                runHook postInstallCheck
              '';

              meta = {
                mainProgram = "node-template";
                description = "node.js template";
                license = licenses.mit;
                platforms = platforms.all;
                badPlatforms = [ systems.inspect.platformPatterns.isStatic ];
                homepage = "https://trev.zip/template/node";
                changelog = "https://trev.zip/template/node/releases";
                downloadPage = "https://trev.zip/template/node/releases/tag/v${final.version}";
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

        # nix flake init -t git+https://trev.zip/template/node
        templates = {
          default = {
            path = ./.;
            description = "node.js template";
            welcomeText = ''
              # node.js template

              `init.sh` requires a git repository with an `origin` remote:

              ```sh
              git init
              git remote add origin <url>
              bash init.sh "Title" "Description"
              ```
            '';
          };
        };

        # nix fmt
        formatter = pkgs.treefmt.withConfig {
          configFile = ./treefmt.toml;
          runtimeInputs = with pkgs; [
            oxfmt
            nixfmt
          ];
        };

        # nix flake check
        checks = pkgs.mkChecks {
          inherit (self.packages.${system}) default;

          node-lint = {
            src = self.packages.${system}.default;
            packages = with pkgs; [
              oxfmt
              oxlint
            ];
            script = ''
              oxfmt --check
              oxlint --deny-warnings
            '';
          };

          nix = {
            root = ./.;
            filter = file: file.hasExt "nix";
            packages = with pkgs; [
              nixfmt
            ];
            script = ''
              nixfmt --check "$file"
            '';
          };

          action = {
            root = ./.;
            files = ./action.yaml;
            packages = with pkgs; [
              action-validator
              zizmor
            ];
            script = ''
              action-validator "$file"
              zizmor --offline "$file"
            '';
          };

          actions-gh = {
            root = ./.github/workflows;
            filter = file: file.hasExt "yaml";
            packages = with pkgs; [
              action-validator
              zizmor
            ];
            script = ''
              action-validator "$file"
              zizmor --offline "$file"
            '';
          };

          actions-fj = {
            root = ./.forgejo/workflows;
            filter = file: file.hasExt "yaml";
            packages = with pkgs; [
              forgejo-runner
              zizmor
            ];
            script = ''
              forgejo-runner validate --workflow --path "$file"
              zizmor --offline "$file"
            '';
          };

          renovate-gh = {
            root = ./.github;
            files = ./.github/renovate.json;
            packages = with pkgs; [
              renovate
            ];
            script = ''
              renovate-config-validator renovate.json
            '';
          };

          renovate-fj = {
            root = ./.forgejo;
            files = ./.forgejo/renovate.json;
            packages = with pkgs; [
              renovate
            ];
            script = ''
              renovate-config-validator renovate.json
            '';
          };

          config = {
            root = ./.;
            filter = file: file.hasExt "json" || file.hasExt "yaml" || file.hasExt "toml" || file.hasExt "md";
            include = [ ./.oxfmtrc.json ];
            packages = with pkgs; [
              oxfmt
            ];
            script = ''
              oxfmt --check
            '';
          };
        };
      }
    );
}
