# node.js template

[![check](https://img.shields.io/github/actions/workflow/status/spotdemo4/node-template/check.yaml?branch=main&logo=github&logoColor=%23bac2de&label=check&labelColor=%23313244)](https://github.com/spotdemo4/node-template/actions/workflows/check.yaml/)
[![vulnerable](https://img.shields.io/github/actions/workflow/status/spotdemo4/node-template/vulnerable.yaml?branch=main&logo=github&logoColor=%23bac2de&label=vulnerable&labelColor=%23313244)](https://github.com/spotdemo4/node-template/actions/workflows/vulnerable.yaml)
[![nix](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2Fspotdemo4%2Fnode-template%2Frefs%2Fheads%2Fmain%2Fflake.lock&query=%24.nodes.nixpkgs.original.ref&logo=nixos&logoColor=%23bac2de&label=channel&labelColor=%23313244&color=%234d6fb7)](https://nixos.org/)
[![node](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2Fspotdemo4%2Fnode-template%2Frefs%2Fheads%2Fmain%2Fpackage.json&query=%24.engines.node&logo=nodedotjs&logoColor=%23bac2de&label=version&labelColor=%23313244&color=%23339933)](https://nodejs.org/en/about/previous-releases)
[![flakehub](https://img.shields.io/endpoint?url=https://flakehub.com/f/spotdemo4/node-template/badge&labelColor=%23313244)](https://flakehub.com/flake/spotdemo4/node-template)

template for starting [node.js](https://nodejs.org) projects

part of [spotdemo4/templates](https://github.com/spotdemo4/templates)

## requirements

- [nix](https://nixos.org/)
- [direnv](https://direnv.net/) (optional)

## getting started

initialize direnv:

```elm
ln -s .envrc.project .envrc &&
direnv allow
```

or manually enter the development environment:

```elm
nix develop
```

then install dependencies:

```elm
npm i
```

### run

```elm
nix run #dev
```

### build

```elm
nix build
```

### check

```elm
nix flake check
```

### release

releases are automatically created for [significant](https://www.conventionalcommits.org/en/v1.0.0/#summary) changes

to manually create a version bump:

```elm
bumper .github/README.md
```

## use

### download

| Architecture | Download                                                                                                                                     |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------------------- |
| amd64        | [node-template_0.6.6_amd64.AppImage](https://github.com/spotdemo4/node-template/releases/download/v0.6.6/node-template_0.6.6_amd64.AppImage) |
| arm64        | [node-template_0.6.6_arm64.AppImage](https://github.com/spotdemo4/node-template/releases/download/v0.6.6/node-template_0.6.6_arm64.AppImage) |

### docker

```elm
docker run ghcr.io/spotdemo4/node-template:0.6.6
```

### action

```yaml
- name: node template
  uses: spotdemo4/node-template@v0.6.6
```

### nix

```elm
nix run github:spotdemo4/node-template
```

### npm

```elm
npx github:spotdemo4/node-template
```
