# Agent Instructions

- Never run real build or compile commands by default, including `nix build`, `just switch`, `just boot`, or similar activation/build tests.
  - Searching packages, checking options, reading documentation, and evaluating snippets is encouraged.
  - The restriction applies only to direct compiling, building, or activating.
- Do not execute any tests unless explicitly instructed.
- Never edit `flake.lock`.

# Development Rules

- Never search `/nix/store` directly (or anything equivalent). Prefer:
  ```sh
  nix flake archive --json
  ```
- Never execute `nix flake archive --json` together with commands that immediately search its output, as this forces unnecessary review.
  - Run `nix flake archive --json` once.
  - Refer to the resulting store path literally in subsequent commands.
  - **Do not** use variables, for example:
    ```sh
    NIXPKGS=/nix/store/... rg "$NIXPKGS"
    ```
    or
    ```sh
    np=/nix/store/...
    sed -n 258,275p "$np/lib/modules.nix"
    ```
  - Instead, use the literal `/nix/store/...` path in each later command.
- Always prefer the new Nix CLI (`nix` commands).
  - Use `nix build` instead of `nix-build`.
  - Apply the same principle to all other commands.

# Nix Style Rules

## General

- Prefer `lib.lists.singleton` over a single-item list.
- Always inherit using the full submodule path:
  ```nix
  let
    inherit (lib.lists) head;
  ```
  Never:
  ```nix
  inherit (lib) head;
  ```
  unless the attribute has no submodule path.
- Always use the Dendritic Pattern (flake-parts `*.mod.nix` auto-discovery).
- Never use `rec`.
  - If recursion is required, define a custom `fix`.
- Do not use `builtins.` inside modules.
- Never use `toString` for paths that need to preserve derivation contexts.
  - Always write:
    ```nix
    "${path}"
    ```

## Executables

- Prefer:
  ```nix
  ${getExe pkgs.something}
  ```
  over bare command names in shell aliases.
- When the executable is used multiple times:
  ```nix
  package = getExe pkgs.something;
  ```

## Module Structure

- Leave an empty line between unrelated options.
- Order module keys as follows:
  1. Environment variables
  2. Aliases
  3. Packages
  4. XDG configuration
  5. Program-specific configuration
- Never duplicate module-system values in `let` bindings.
  - If a value is provided through `config.*`, always reference `config.*`.
  - `let` bindings are only appropriate for:
    - computed derivations,
    - helper functions,
    - `getExe` shortcuts.
- Prefer destructuring module arguments when it improves clarity:
  ```nix
  { home, ... }:
  ```
  instead of:
  ```nix
  value: value.home
  ```
- Prefer setting individual options with `mkIf`:
  ```nix
  foo.bar = mkIf condition value;
  ```
  instead of:
  ```nix
  foo = mkIf condition {
    bar = value;
  };
  ```

## Packages

- Inline package definitions should use:
  ```nix
  pkgs.callPackage ({ stdenv, writeText }: ...) { }
  ```
- For inline source code, use `writeText` directly in the `src` attribute instead of a separate `let` binding.
- If a package is its own concern (for example, a custom C tool), place its `perSystem` definition in its own `.mod.nix` file rather than the module that consumes it.

## Formatting

- Always prefix multiline code strings with a language annotation:
  ```nix
  /* bash */ ''
    ...
  ''
  ```
- Category comments should be uppercase and have no trailing period:
  ```nix
  # DOCK
  ```
  not:
  ```nix
  # Dock.
  ```

## Functional Style

- Prefer `<|` (pipe-last) over parentheses when the parenthesized expression is the final argument:
  ```nix
  mkIf condition <| toJSON { ... }
  ```
  instead of:
  ```nix
  mkIf condition (toJSON { ... })
  ```
- Do **not** use `<|` when the final argument is:
  - an `if` expression,
  - a `let` expression,
  - a lambda.

## CLI Style

- In source files, never use short-form CLI arguments if a long-form equivalent exists.
- Short-form flags are acceptable only for interactive use.
- Never use short-form flags in scripts intended for the user.
