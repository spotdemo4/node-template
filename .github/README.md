# node.js template

[![check](https://github.com/spotdemo4/node-template/actions/workflows/check.yaml/badge.svg?branch=main)](https://github.com/spotdemo4/node-template/actions/workflows/check.yaml)
[![vulnerable](https://github.com/spotdemo4/node-template/actions/workflows/vulnerable.yaml/badge.svg?branch=main)](https://github.com/spotdemo4/node-template/actions/workflows/vulnerable.yaml)

Template for starting [node.js](https://nodejs.org) projects, part of [spotdemo4/templates](https://github.com/spotdemo4/templates)

## Requirements

- [nix](https://nixos.org/)
- [direnv](https://direnv.net/) (optional)

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

Releases are automatically created for [significant](https://www.conventionalcommits.org/en/v1.0.0/#summary) changes.

To manually create a new release:

```elm
bumper .github/README.md
```

## Use

### Download

| OS      | Architecture | Download                                                                                                                                           |
| ------- | ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| Linux   | amd64        | [node-template_0.6.0_linux_amd64.xz](https://github.com/spotdemo4/node-template/releases/download/v0.6.0/node-template_0.6.0_linux_amd64.xz)       |
| Linux   | arm64        | [node-template_0.6.0_linux_arm64.xz](https://github.com/spotdemo4/node-template/releases/download/v0.6.0/node-template_0.6.0_linux_arm64.xz)       |
| MacOS   | arm64        | [node-template_0.6.0_darwin_arm64.xz](https://github.com/spotdemo4/node-template/releases/download/v0.6.0/node-template_0.6.0_darwin_arm64.xz)     |
| Windows | amd64        | [node-template_0.6.0_windows_amd64.zip](https://github.com/spotdemo4/node-template/releases/download/v0.6.0/node-template_0.6.0_windows_amd64.zip) |

### Docker

```elm
docker run ghcr.io/spotdemo4/node-template:0.6.0
```

### Action

```yaml
- name: node template
  uses: spotdemo4/node-template@v0.6.0
```

### Nix

```elm
nix run github:spotdemo4/node-template
```

### npm

```elm
npx github:spotdemo4/node-template
```
