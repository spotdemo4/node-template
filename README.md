# node.js template

[![check](https://trev.zip/template/node/actions/workflows/check.yaml/badge.svg?branch=main&logo=forgejo&logoColor=%23bac2de&label=check&labelColor=%23313244)](https://trev.zip/template/node/actions?workflow=check.yaml)
[![vulnerable](https://trev.zip/template/node/actions/workflows/vulnerable.yaml/badge.svg?branch=main&logo=forgejo&logoColor=%23bac2de&label=vulnerable&labelColor=%23313244)](https://trev.zip/template/node/actions?workflow=vulnerable.yaml)
[![nixpkgs](https://img.shields.io/endpoint?url=https%3A%2F%2Fnix-shield.trev.zip%2Fbadge%3Furl%3Dhttps%253A%252F%252Ftrev.zip%252Ftemplate%252Fnode%252Fraw%252Fbranch%252Fmain%252Fflake.lock%26input%3Dnixpkgs&logoColor=%23bac2de&labelColor=%23313244&color=%235277C3)](https://nixos.org/)
[![node](https://img.shields.io/badge/dynamic/json?url=https://trev.zip/template/node/raw/branch/main/package.json&query=%24.engines.node&logo=nodedotjs&logoColor=%23bac2de&label=version&labelColor=%23313244&color=%23339933)](https://nodejs.org/en/about/previous-releases)

template for starting [node.js](https://nodejs.org) projects

part of [spotdemo4/templates](https://github.com/spotdemo4/templates)

## requirements

- [nix](https://nixos.org/)

## getting started

```sh
nix develop
./init.sh "Title" "Description"
npm install
```

### run

```sh
npm run dev
```

### format

```sh
nix fmt
```

### check

```sh
nix flake check
```

### build

```sh
nix build
```

### release

```sh
bumper
```

releases are automatically created for [significant](https://www.conventionalcommits.org/en/v1.0.0/#summary) changes

## use

### npm

```sh
NPM_CONFIG_REGISTRY=https://trev.zip/api/packages/template/npm/ \
    npx node-template
```

### docker

```sh
docker run trev.zip/template/node:latest
```

### nix

```sh
nix run git+https://trev.zip/template/node.git
```

### action

```yaml
- uses: spotdemo4/node-template@main
```

### download

https://trev.zip/template/node/releases
