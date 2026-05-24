# Repository Guidelines

## Project Structure & Module Organization

This repository is a Nix flake for a NixOS system configuration:

- `flake.nix` defines inputs and exports `nixosConfigurations`.
- `hosts/` contains host-specific systems. The current host is `hosts/light/`.
- `system/` contains shared NixOS modules, grouped by concern: `core/`, `hardware/`, `network/`, `programs/`, and `services/`.
- `home/` contains Home Manager modules for user programs, shell, editors, terminals, Wayland, and scripts.
- `settings/` contains small shared values.
- Assets live near consumers, for example `home/wayland/niri/wallpapers/`.

Prefer adding a small module in the relevant directory, then importing it from that directory's `default.nix`.

## Build, Test, and Development Commands

- `just switch` applies the flake to the current NixOS system.
- `just boot` builds and registers the system for next boot.
- `just up` updates flake inputs, then switches.
- `just history` and `just curgen` inspect system generations.

These commands are documented for maintainers. Agents should not run build, switch, boot, or activation commands unless explicitly asked.

## Coding Style & Naming Conventions

Nix files use two-space indentation and small attribute sets. Keep modules focused on one concern, and match names such as `networkmanager.nix`, `sysctl.nix`, `kitty.nix`, and `niri.nix`.

Use lowercase, descriptive file names. Prefer directory-level `default.nix` files to collect imports. Put shared constants in `settings/` only when multiple modules need them.

## Testing Guidelines

There is no standalone test suite. Prefer non-building checks:

- Use Nix option/package searches and evaluation commands for validation.
- Do not run real build, compile, or system activation tests unless explicitly asked.

For Home Manager or service changes, document intended manual runtime checks in the PR.

## Agent-Specific Instructions

Do not revert unrelated local changes. Inspect `git status --short` before modifying files and keep changes surgical.

Never run real build or compile commands by default, including `nix build`, `just switch`, `just boot`, or similar activation/build tests. Searching packages, checking options, reading docs, and evaluating snippets is encouraged; the restriction is only on direct compiling, building, or activating.

# Nix Style Rules

- Prefer `lib.lists.singleton` over a single item list.
- Always `let inherit (lib.<path>) foo;` with full paths like `lib.lists.head`,
  never `inherit (lib) foo` unless `foo` has no submodule path.
- Always prefer `${getExe pkgs.something}` over bare command names in shell
  aliases. Use `package = getExe pkgs.something` when there are multiple usages.
- Leave an empty line between unrelated options.
- Module key order: environment variables, aliases, packages, XDG config,
  program-specific configuration.
- Prefer destructuring attrset arguments when it improves clarity. Use
  `{ home, ... }:` instead of `value: value.home` where it makes sense.
- Always put `/* lang */` before multiline code strings, e.g. `/* bash */ ''`.
- Category/section comments should be uppercase with no period, e.g. `# DOCK`,
  not `# Dock.`.
- Prefer setting individual options with `mkIf` over wrapping entire attrsets.
  Use `foo.bar = mkIf condition value;` not
  `foo = mkIf condition { bar = value; };` when possible.
- Inline package definitions should use `pkgs.callPackage` with destructured
  args, e.g. `pkgs.callPackage ({ stdenv, writeText }: ...) { }`.
- For inline source code in packages, use `writeText` directly in the `src`
  attribute rather than a separate `let` binding.
- Prefer `<|` (pipe-last) over parentheses when the parenthesized expression is
  the final argument to a function. E.g. `mkIf condition <| toJSON { ... }`
  instead of `mkIf condition (toJSON { ... })`. Does not apply when the
  parenthesized expression is not the last argument (e.g.
  `callPackage (...) { }`). Does not work with `if`, `let`, or lambda
  expressions on the RHS — those still need parentheses.
- Do not use `builtins.` in modules.
- Never use `rec` ever. Worst case, define a custom `fix`.
