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
  };

  outputs =
    {
      nixpkgs,
      trev,
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
        fs = pkgs.lib.fileset;
        node = pkgs.nodejs_24;
        node-slim = pkgs.nodejs-slim_24;
      in
      rec {
        devShells = {
          default = pkgs.mkShell {
            name = "dev";
            shellHook = pkgs.shellhook.ref;
            packages = with pkgs; [
              # node
              node

              # lint
              biome
              nixfmt
              prettier

              # util
              bumper
              flake-release
            ];
          };

          bump = pkgs.mkShell {
            name = "bump";
            packages = with pkgs; [
              bumper
            ];
          };

          release = pkgs.mkShell {
            name = "release";
            packages = with pkgs; [
              flake-release
            ];
          };

          update = pkgs.mkShell {
            name = "update";
            packages = with pkgs; [
              renovate

              # npm i
              node
            ];
          };

          vulnerable = pkgs.mkShell {
            name = "vulnerable";
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
            ];
            script = ''
              biome ci
            '';
          };

          nix = {
            src = fs.toSource {
              root = ./.;
              fileset = fs.fileFilter (file: file.hasExt "nix") ./.;
            };
            deps = with pkgs; [
              nixfmt-tree
            ];
            script = ''
              treefmt --ci
            '';
          };

          renovate = {
            src = fs.toSource {
              root = ./.github;
              fileset = ./.github/renovate.json;
            };
            deps = with pkgs; [
              renovate
            ];
            script = ''
              renovate-config-validator renovate.json
            '';
          };

          actions = {
            src = fs.toSource {
              root = ./.;
              fileset = fs.unions [
                ./action.yaml
                ./.github/workflows
              ];
            };
            deps = with pkgs; [
              action-validator
              octoscan
            ];
            script = ''
              action-validator **/*.yaml
              octoscan scan .
            '';
          };

          prettier = {
            src = fs.toSource {
              root = ./.;
              fileset = fs.fileFilter (file: file.hasExt "yaml" || file.hasExt "json" || file.hasExt "md") ./.;
            };
            deps = with pkgs; [
              prettier
            ];
            script = ''
              prettier --check .
            '';
          };
        };

        apps = pkgs.lib.mkApps {
          dev.script = "npm run dev";
        };

        packages = with pkgs.lib; rec {
          default = pkgs.buildNpmPackage (finalAttrs: {
            pname = "node-template";
            version = "0.6.1";

            src = fs.toSource {
              root = ./.;
              fileset = fs.difference ./. (
                fs.unions [
                  ./.github
                  ./.vscode
                  ./flake.nix
                  ./flake.lock
                ]
              );
            };

            nodejs = node;
            npmConfigHook = pkgs.importNpmLock.npmConfigHook;
            npmDeps = pkgs.importNpmLock {
              npmRoot = finalAttrs.src;
            };
            nativeBuildInputs = with pkgs; [
              makeWrapper
            ];

            doCheck = false;

            installPhase = ''
              runHook preInstall

              mkdir -p $out/{bin,lib/node_modules/node-template}
              cp -r build node_modules package.json $out/lib/node_modules/node-template

              makeWrapper "${getExe node-slim}" "$out/bin/node-template" \
                --add-flags "$out/lib/node_modules/node-template/build/index.js"

              runHook postInstall
            '';

            meta = {
              description = "node template";
              mainProgram = "node-template";
              homepage = "https://github.com/spotdemo4/node-template";
              changelog = "https://github.com/spotdemo4/node-template/releases/tag/v${finalAttrs.version}";
              license = licenses.mit;
              platforms = platforms.all;
            };
          });

          image = pkgs.dockerTools.buildLayeredImage {
            name = default.pname;
            tag = default.version;

            contents = with pkgs; [
              dockerTools.caCertificates
            ];

            created = "now";
            meta = default.meta;

            config = {
              Entrypoint = [ "${meta.getExe default}" ];
              Labels = {
                "org.opencontainers.image.title" = default.pname;
                "org.opencontainers.image.description" = default.meta.description;
                "org.opencontainers.image.version" = default.version;
                "org.opencontainers.image.source" = default.meta.homepage;
                "org.opencontainers.image.licenses" = default.meta.license.spdxId;
              };
            };
          };

          # cross compilation
          linux-amd64 = deno.compile {
            package = default;
            target = "x86_64-unknown-linux-gnu";
          };
          linux-arm64 = deno.compile {
            package = default;
            target = "aarch64-unknown-linux-gnu";
          };
          darwin-arm64 = deno.compile {
            package = default;
            target = "aarch64-apple-darwin";
          };
          windows-amd64 = deno.compile {
            package = default;
            target = "x86_64-pc-windows-msvc";
          };
        };

        formatter = pkgs.nixfmt-tree;
      }
    );
}
