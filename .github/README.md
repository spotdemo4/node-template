# node template

![check](https://github.com/spotdemo4/node-template/actions/workflows/check.yaml/badge.svg)
![vulnerable](https://github.com/spotdemo4/node-template/actions/workflows/vulnerable.yaml/badge.svg)

Template for starting [Node.js](https://nodejs.org) projects.

Part of [spotdemo4/templates](https://github.com/spotdemo4/templates)

## Requirements

- [Nix](https://nixos.org/) package manager
- (optional) [direnv](https://direnv.net/)

## Getting started

Initialize direnv:

```elm
ln -s .envrc.project .envrc &&
direnv allow
```

or enter the dev shell manually:

```elm
nix develop
```

then install dependencies:

```elm
npm i
```

## Running

```elm
npm run dev
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

Releases are automatically created for significant changes.

To manually create a new release:

```elm
bumper
```
