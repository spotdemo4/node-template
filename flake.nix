{
  description = "node.js template";

  nixConfig = {
    extra-substituters = [
      "https://cache.trev.zip/nur"
    ];
    extra-trusted-public-keys = [
      "nur:70xGHUW1+1b8FqBchldaunN//pZNVo6FKuPL4U/n844="
    ];
  };

  inputs = {
    systems.url = "github:nix-systems/default";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    trev = {
      url = "github:spotdemo4/nur";
      inputs.systems.follows = "systems";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    semgrep-rules = {
      url = "github:semgrep/semgrep-rules";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      trev,
      semgrep-rules,
      ...
    }:
    trev.libs.mkFlake (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            trev.overlays.packages
            trev.overlays.libs
          ];
        };
        node = pkgs.nodejs_24;
        node-slim = pkgs.nodejs-slim_24;
      in
      rec {
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # node
              node

              # util
              bumper

              # lint
              biome
              nixfmt
              prettier
            ];
            shellHook = pkgs.shellhook.ref;
          };

          bump = pkgs.mkShell {
            packages = with pkgs; [
              nix-update
            ];
          };

          release = pkgs.mkShell {
            packages = with pkgs; [
              skopeo
              podman
            ];
          };

          update = pkgs.mkShell {
            packages = with pkgs; [
              renovate

              # npm
              node
            ];
          };

          vulnerable = pkgs.mkShell {
            packages = with pkgs; [
              # node
              node

              # nix
              flake-checker

              # actions
              octoscan
            ];
          };
        };

        checks = pkgs.lib.mkChecks {
          node = {
            src = packages.default;
            deps = with pkgs; [
              biome
              opengrep
            ];
            script = ''
              biome ci
              opengrep scan \
                --quiet \
                --error \
                --use-git-ignore \
                --config="${semgrep-rules}/javascript" \
                --config="${semgrep-rules}/typescript"
            '';
          };

          nix = {
            src = ./.;
            deps = with pkgs; [
              nixfmt-tree
            ];
            script = ''
              treefmt --ci
            '';
          };

          actions = {
            src = ./.;
            deps = with pkgs; [
              prettier
              action-validator
              octoscan
              renovate
            ];
            script = ''
              prettier --check "**/*.json" "**/*.yaml"
              action-validator .github/**/*.yaml
              octoscan scan .github
              renovate-config-validator .github/renovate.json
            '';
          };
        };

        apps = pkgs.lib.mkApps {
          dev = {
            deps = [
              node
            ];
            script = ''
              npm run dev
            '';
          };
        };

        packages.default = pkgs.buildNpmPackage (finalAttrs: {
          pname = "node-template";
          version = "0.1.11";
          src = builtins.path {
            name = "root";
            path = ./.;
          };
          nodejs = node;

          npmDeps = pkgs.importNpmLock {
            npmRoot = finalAttrs.src;
          };

          npmConfigHook = pkgs.importNpmLock.npmConfigHook;

          nativeBuildInputs = with pkgs; [
            makeWrapper
          ];

          doCheck = false;

          installPhase = ''
            runHook preInstall

             mkdir -p $out/{bin,lib/node_modules/node-template}
             cp -r build node_modules package.json $out/lib/node_modules/node-template

             makeWrapper "${pkgs.lib.getExe node-slim}" "$out/bin/node-template" \
               --add-flags "$out/lib/node_modules/node-template/build/index.js"

             runHook postInstall
          '';

          meta = {
            description = "node template";
            mainProgram = "node-template";
            homepage = "https://github.com/spotdemo4/node-template";
            changelog = "https://github.com/spotdemo4/node-template/releases/tag/v${finalAttrs.version}";
            license = pkgs.lib.licenses.mit;
            platforms = pkgs.lib.platforms.all;
          };
        });

        formatter = pkgs.nixfmt-tree;
      }
    );
}
