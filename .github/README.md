# node.js template

![check](https://github.com/spotdemo4/node-template/actions/workflows/check.yaml/badge.svg?branch=main)
![vulnerable](https://github.com/spotdemo4/node-template/actions/workflows/vulnerable.yaml/badge.svg?branch=main)

Template for starting [node.js](https://nodejs.org) projects, part of [spotdemo4/templates](https://github.com/spotdemo4/templates)

## Requirements

- [nix](https://nixos.org/)
- (optional) [direnv](https://direnv.net/)

## Getting started

Initialize direnv:

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

## Run

```elm
nix run #dev
```

## Build

```elm
nix build
```

## Check

```elm
nix flake check
```

## Release

Releases are automatically created for significant changes.

To manually create a new release:

```elm
bumper
```

## Use

### Binary

| OS      | Architecture | Download                                                                                                                                                   |
| ------- | ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Linux   | amd64        | [node-template-0.2.2-x86_64-linux.tar.xz](https://github.com/spotdemo4/node-template/releases/download/v0.2.2/node-template-0.2.2-x86_64-linux.tar.xz)     |
| Linux   | arm64        | [node-template-0.2.2-aarch64-linux.tar.xz](https://github.com/spotdemo4/node-template/releases/download/v0.2.2/node-template-0.2.2-aarch64-linux.tar.xz)   |
| MacOS   | arm64        | [node-template-0.2.2-aarch64-darwin.tar.xz](https://github.com/spotdemo4/node-template/releases/download/v0.2.2/node-template-0.2.2-aarch64-darwin.tar.xz) |
| Windows | amd64        | [node-template-0.2.2-x86_64-windows.zip](https://github.com/spotdemo4/node-template/releases/download/v0.2.2/node-template-0.2.2-x86_64-windows.zip)       |

### npm

```elm
npx github:spotdemo4/node-template
```

### Docker

```elm
docker run ghcr.io/spotdemo4/node-template:0.2.2
```

### Nix

```elm
nix run github:spotdemo4/node-template
```

### Action

Delete `action.yaml` if unneeded

```yaml
- name: node-template
  uses: spotdemo4/node-template@v0.2.2
```
