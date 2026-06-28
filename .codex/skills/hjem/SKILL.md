---
name: hjem
description: Configure and troubleshoot Hjem in Linux NixOS flakes and modules. Use when adding the Hjem flake input or NixOS module, managing hjem.users files and XDG paths, translating dotfiles into Hjem entries, configuring user packages or session variables, reasoning about clobber and linker behavior, or validating a Hjem-backed NixOS configuration.
---

# Hjem

Manage home files through Hjem's small NixOS interface. Keep changes aligned
with the target configuration and avoid treating Hjem as Home Manager.

## Workflow

1. Read the target repository's `AGENTS.md` files and configuration
   conventions.
2. Inspect the flake inputs, imported NixOS modules, `users.users`, existing
   `hjem` configuration, and the pinned Hjem source when available.
3. Read [references/nixos.md](references/nixos.md) for the relevant option
   semantics and examples. Prefer the pinned source over this reference if they
   differ. Use the [official guide](https://hjem.feel-co.org/) and
   [option reference](https://hjem.feel-co.org/options.html) when the pinned
   source is unavailable or newer behavior must be verified.
4. Make the smallest change that expresses the requested home state. Preserve
   the repository's module organization and Nix style.
5. Evaluate the narrowest affected attribute when permitted. Do not rebuild,
   activate, run the full test suite, or update a lock file unless the user
   explicitly authorizes it.

## Configuration rules

- Import `inputs.hjem.nixosModules.default` once in the NixOS module graph.
- Configure an existing NixOS user under `hjem.users.<username>`. Let NixOS
  supply `user` and `directory` defaults unless the configuration requires an
  override.
- Prefer `xdg.config.files`, `xdg.data.files`, `xdg.cache.files`, or
  `xdg.state.files` when the target belongs to an XDG base directory. Use
  `files` for other paths relative to the user's home.
- Choose one content mechanism per entry: `text`, `source`, or
  `generator` with `value`. Prefer structured generators for JSON, TOML, YAML,
  or INI when the configuration already represents the data as Nix values.
- Keep clobbering disabled by default. Set per-file `clobber = true` only when
  replacing an existing unmanaged target is intentional.
- Keep the default manifest linker unless the user specifically requests the
  Linux-only systemd-tmpfiles fallback. Do not combine fallback mode with
  manifest-only file operations.
- Treat `packages` as a convenience alias to the NixOS user's package list, not
  as an independent profile.
- Source `environment.loadEnv` from the user's shell or session startup when
  using `environment.sessionVariables`; Hjem does not inject those variables
  into sessions itself.
- Never put secrets in `text`, generated values, or store-backed sources.
  Recommend a secret-management mechanism that materializes secrets outside
  the Nix store.

## Scope

Support Hjem on NixOS only. Do not introduce nix-darwin, Finix, Hjem Rum,
custom Hjem modules, or per-program abstractions unless the user expands the
request.

When diagnosing activation, inspect Hjem's generated options and systemd units
before changing configuration. Propagate evaluation and activation failures;
do not hide them with fallbacks.
