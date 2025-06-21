# Nix flake templates for dev environments

Use nix flake to declare and lock in dev environments
(e.g. tools, environment variables, init scripts).

This repository is heavily inspired by [the-nix-way/dev-templates](https://github.com/the-nix-way/dev-templates)
and tailored for personal preferences.

## Get started

```sh
# To initialize (where `ENV` is listed in the table below):
nix flake init --template github:whisperpine/dev-templates#ENV

# Here's an example (for the rust template):
nix flake init --template github:whisperpine/dev-templates#rust
# To ensure it's up to date, use `--refresh`:
nix flake init --refresh --template github:whisperpine/dev-templates#rust
```

## How to use the templates

Once your preferred template has been initialized,
you can use the provided shell in two ways:

- If you have [nix-direnv](https://github.com/nix-community/nix-direnv) installed,
  you can initialize the environment by running `direnv allow`.
- If you don't have [nix-direnv](https://github.com/nix-community/nix-direnv) installed,
  you can run `nix develop` to enter the nix-defined shell environment.

## Available templates

```sh
# list all the templates (notice items under "templates"):
nix flake show github:whisperpine/dev-templates
```

- [empty](./empty/): a good start point for any projects.
- [rust](./rust/): manage rust toolchain, targets and others tools.\
  It supersedes the functions of `rustup` in a declarative way.
- [python](./python/): python virtual environment managed by [uv](https://github.com/astral-sh/uv).\
  Notice the shellHook "source .venv/bin/activate", which is essential.
- [web](./web/): web or nodejs dev environment managed by [bun](https://github.com/oven-sh/bun).\
  Notice [web/.envrc](./web/.envrc) extends `PATH` environment variable.
