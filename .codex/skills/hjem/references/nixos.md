# Hjem on NixOS

## Contents

- Installation
- User model
- Managed paths
- File entries
- Packages and environment
- Linkers and activation
- Validation and diagnostics
- Common failures

## Installation

Add Hjem as a flake input and make its nixpkgs input follow the configuration's
nixpkgs:

```nix
inputs.hjem = {
  url = "github:feel-co/hjem";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Import the NixOS module once:

```nix
modules = [
  inputs.hjem.nixosModules.default
];
```

Do not update `flake.lock` unless the user authorizes the input change and lock
update.

## User model

`hjem.users.<username>` must correspond to an enabled
`users.users.<username>`. On NixOS, Hjem defaults:

- `user` to the NixOS user's name.
- `directory` to `users.users.<username>.home`.
- `clobberFiles` to `hjem.clobberByDefault`.
- `enable` to `true`.

An enabled Hjem user whose NixOS user is absent or disabled fails an assertion.
Disabled Hjem users are omitted from file activation and package forwarding.

Prefer the compact form:

```nix
{
  hjem.users.alice = {
    files.".profile".text = "source \"$HOME/.nix-profile/etc/profile.d/nix.sh\"";
    packages = [pkgs.jq];
  };
}
```

Set `user` or `directory` only when the NixOS-derived values are deliberately
wrong for the requested setup.

## Managed paths

Use `files` for targets relative to the user's home:

```nix
hjem.users.alice.files.".local/bin/example".source = ./example;
```

Use XDG collections for paths relative to their base directories:

```nix
hjem.users.alice.xdg.config.files."jj/config.toml" = {
  generator = (pkgs.formats.toml { }).generate "jj-config.toml";
  value = {
    user.name = "Alice";
  };
};
```

Available collections are:

- `xdg.cache.files`, defaulting below `$HOME/.cache`.
- `xdg.config.files`, defaulting below `$HOME/.config`.
- `xdg.data.files`, defaulting below `$HOME/.local/share`.
- `xdg.state.files`, defaulting below `$HOME/.local/state`.

Each base has a configurable `directory`. When a directory differs from its
default, Hjem adds the matching `XDG_*_HOME` value to
`environment.sessionVariables`; the session must still source
`environment.loadEnv`.

Configure MIME associations through:

```nix
hjem.users.alice.xdg.mime-apps = {
  default-applications."text/html" = "firefox.desktop";
  added-associations."text/html" = ["firefox.desktop"];
  removed-associations."text/xml" = ["legacy.desktop"];
};
```

Hjem generates `mimeapps.list` only when at least one association differs from
its default.

## File entries

Every file entry supports:

- `enable`: Include the entry; defaults to `true`.
- `type`: One of `symlink`, `copy`, `delete`, `directory`, or `modify`;
  defaults to `symlink`.
- `target`: A path relative to the collection's base. Absolute targets are
  rejected.
- `clobber`: Replace an existing unmanaged target; inherits the user and global
  defaults, which are `false` by default.
- `executable`: Make a file created through `text` executable.

Content can come from exactly one practical mechanism:

- `text`: Create a store file from literal text and link or copy it.
- `source`: Use a file or directory path from the Nix store.
- `generator` plus `value`: Apply a function to an attribute set. The function
  must return text or a path.

Examples:

```nix
hjem.users.alice = {
  files.".motd".text = "Managed by Hjem\n";

  xdg.config.files."app/config.json" = {
    generator = lib.generators.toJSON { };
    value = {
      enabled = true;
    };
  };

  xdg.config.files."app/theme".source = ./theme;
};
```

`source` is required for `symlink` unless `text` or a generator produces it.
For `copy`, the source must be an individual file. `delete`, `directory`, and
`modify` do not accept a source. `permissions`, `uid`, and `gid` apply only to
`copy`, `delete`, `directory`, and `modify`; permissions must contain three or
four octal digits.

Use mutation-oriented types only with the default manifest linker:

```nix
hjem.users.alice.files = {
  "copied.conf" = {
    type = "copy";
    source = ./copied.conf;
    permissions = "0600";
  };

  "obsolete.conf".type = "delete";
  ".local/state/example".type = "directory";

  ".local/state/example.db" = {
    type = "modify";
    permissions = "0600";
  };
};
```

Do not store credentials or other secrets through these content mechanisms.
Nix store content is not a secret store.

## Packages and environment

`hjem.users.<username>.packages` is forwarded to
`users.users.<username>.packages`. The official documentation describes this
interface as experimental. Avoid setting the same package list through both
paths without a reason.

`extraDependencies` keeps paths in the system closure without exposing them in
the user's package list. On NixOS it is forwarded to
`system.extraDependencies`.

Configure session variables as strings, integers, paths, null values, or lists:

```nix
hjem.users.alice.environment.sessionVariables = {
  EDITOR = "nvim";
  PATH = ["/home/alice/.local/bin"];
};
```

List values are joined with colons. Hjem writes a read-only POSIX shell script
to `environment.loadEnv`; it does not source the script. Reference that option
from the user's shell or graphical-session initialization.

## Linkers and activation

The default `hjem.linker` is `smfh`. Hjem builds one versioned manifest per
enabled user and NixOS activates changes through systemd services. This mode
supports all file types and removes stale managed links by comparing the new
manifest with the previously activated manifest.

Setting `hjem.linker = null` selects the Linux-only systemd-tmpfiles fallback.
That fallback handles symlink-style entries and does not provide the full
manifest operation set. Keep the default unless the user has a specific reason
to accept those limitations.

`hjem.clobberByDefault` controls the global default, `clobberFiles` overrides it
per user, and an entry's `clobber` overrides both. Prefer the entry-level option
for isolated conflicts.

## Validation and diagnostics

Honor the target repository's command policy first. Use narrow, read-only
evaluation when allowed:

```sh
nix eval --json '.#nixosConfigurations.HOST.config.hjem.users.USER.files'
nix eval --raw '.#nixosConfigurations.HOST.config.hjem.users.USER.environment.loadEnv'
```

Replace `HOST` and `USER` with actual attribute names. Quote installables that
contain shell-significant characters.

Inspect activation without changing state:

```sh
systemctl status hjem.target
systemctl status 'hjem-activate@USER.service'
journalctl --unit 'hjem-activate@USER.service'
```

Evaluate the exact generated entry when debugging path, source, target, or
clobber values. Do not run a rebuild, switch, boot, activation service, full
flake check, or lock update without authorization.

## Common failures

- **Unknown `hjem` option:** The NixOS module was not imported into the relevant
  configuration.
- **Enabled Hjem user assertion:** Define and enable the matching NixOS user, or
  disable/remove its Hjem configuration.
- **Existing unmanaged target:** Preserve it, migrate it deliberately, or set
  entry-level `clobber = true` with user approval.
- **Absolute target rejection:** Put the path in the correct collection and use
  a relative `target`.
- **Missing source:** Provide `source`, `text`, or a valid generator for
  `symlink` and `copy`.
- **Invalid type fields:** Remove ownership or permission fields from symlinks,
  and remove sources from `delete`, `directory`, and `modify`.
- **Variables absent at runtime:** Source `environment.loadEnv` in the relevant
  shell or session startup.
- **Advanced type ignored with `linker = null`:** Restore the default manifest
  linker or express the requirement outside Hjem's fallback.
