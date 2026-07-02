# `hx` process CLI

This snapshot describes Helix 25.07.1. Run `hx --help` for the installed
version before relying on version-sensitive flags.

## Opening files

```text
hx [FLAGS] [files]...
```

- Open a position with `file[:row[:col]]`.
- Use `+[N]` to open the first file at line `N`; omit `N` for the last line.
- Use `--vsplit` or `--hsplit` to split supplied files.
- Use `-w, --working-dir PATH` to set the initial working directory.
- Use `-c, --config FILE` to select a configuration file.

## Diagnostics

`--health [CATEGORY]` checks editor setup. Categories may be a language or:

- `clipboard`
- `languages`
- `all-languages`
- `all`

Without a category, health behaves like `all` with languages filtered by user
configuration. Use a narrow category first.

Increase logging with repeated `-v` flags, up to three levels. Use
`--log FILE` to select the log destination. Inside Helix, `:log-open` opens the
active log.

`--strict` exits on errors from commands that can fail. Use it for automated
validation where a nonzero result must be visible.

## Grammars and utility modes

- `-g, --grammar fetch` fetches configured tree-sitter grammars.
- `-g, --grammar build` builds configured tree-sitter grammars.
- `--tutor` opens the tutorial.
- `-V, --version` prints the installed version.

The top-level `use-grammars` setting in `languages.toml` can restrict grammar
fetch/build to an `only` or `except` list.
