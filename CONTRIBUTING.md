# contributing

## requirements

- [nix](https://nixos.org/)

## getting started

```sh
nix develop
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
