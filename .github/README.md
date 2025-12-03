# node template

![check](https://github.com/spotdemo4/node-template/actions/workflows/check.yaml/badge.svg)
![vulnerable](https://github.com/spotdemo4/node-template/actions/workflows/vulnerable.yaml/badge.svg)

Template for starting [Node.js](https://nodejs.org) projects, part of [spotdemo4/templates](https://github.com/spotdemo4/templates)

## Requirements

- [nix](https://nixos.org/) package manager
- (optional) [direnv](https://direnv.net/)

## Getting started

Initialize direnv:

```elm
ln -s .envrc.project .envrc &&
direnv allow
```

or enter the dev environment manually:

```elm
nix develop
```

then install dependencies:

```elm
npm i
```

## Running

```elm
nix run #dev
```

## Building

```elm
nix build
```

## Checking

```elm
nix flake check
```

## Releasing

Releases are automatically created for significant changes

To manually create a new release:

```elm
bumper
```

## Using

### Binary

| OS      | Architecture | Download                                                                                                                 |
| ------- | ------------ | ------------------------------------------------------------------------------------------------------------------------ |
| Linux   | x86_64       | [tar.xz](https://github.com/spotdemo4/node-template/releases/latest/download/node-template-0.1.17-x86_64-linux.tar.xz)   |
| Linux   | aarch64      | [tar.xz](https://github.com/spotdemo4/node-template/releases/latest/download/node-template-0.1.17-aarch64-linux.tar.xz)  |
| MacOS   | aarch64      | [tar.xz](https://github.com/spotdemo4/node-template/releases/latest/download/node-template-0.1.17-aarch64-darwin.tar.xz) |
| Windows | x86_64       | [zip](https://github.com/spotdemo4/node-template/releases/latest/download/node-template-0.1.17-x86_64-windows.zip)       |

### NPM

```elm
npx github:spotdemo4/node-template
```

### Docker

```elm
docker run ghcr.io/spotdemo4/node-template:latest
```

### Nix

```elm
nix run github:spotdemo4/node-template
```
