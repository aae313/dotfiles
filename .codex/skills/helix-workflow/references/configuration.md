# Helix workflow configuration

## Contents

- [Shell](#shell)
- [Picker and explorer](#picker-and-explorer)
- [Formatters](#formatters)
- [Languages and servers](#languages-and-servers)
- [Roots](#roots)

## Shell

`editor.shell` is the command Helix uses for external commands. The Unix
default is `["sh", "-c"]`; Windows defaults to `["cmd", "/C"]`. Shell-backed
keymaps must use syntax valid for the configured command.

Do not change `editor.shell` merely because the user's login shell differs.
Changing it affects every Helix shell expansion and shell command.

## Picker and explorer

`editor.file-picker` controls hidden files, symlinks, parent ignore files,
`.ignore`, Git ignore sources, and traversal depth. These settings also affect
global search.

`editor.file-explorer` exposes a similar set but defaults to showing most
files. Helix-specific ignore files can be workspace-local at `.helix/ignore`
or global in the Helix configuration directory.

## Formatters

A language formatter receives the original buffer on stdin and must emit the
formatted buffer on stdout:

```toml
[[language]]
name = "mylang"
formatter = { command = "formatter", args = ["--stdin", "--stdin-filename", "%{buffer_name}"] }
```

Formatter arguments support command-line expansions. An explicit formatter
takes precedence over LSP formatting. Configure `auto-format` at the editor
and language levels as required.

## Languages and servers

Language configuration merges in this order:

1. Built-in `languages.toml`.
2. User configuration directory `languages.toml`.
3. Project `.helix/languages.toml`.

Language-server processes require a `command` available on `PATH`; optional
fields include `args`, `config`, `timeout`, `environment`, and
`required-root-patterns`.

Multiple servers are ordered. The first supporting server handles most
features, while diagnostics, code actions, completion, document symbols, and
workspace symbols are merged across enabled servers. Use `only-features` or
`except-features` to divide responsibility explicitly.

`:config-reload` refreshes configuration. Some settings, including LSP
snippets, require `:lsp-restart`.

## Roots

The workspace root is discovered once by walking upward from Helix's current
working directory to the nearest `.git`, `.svn`, `.jj`, or `.helix`.

LSP root selection is separate:

- Start at the opened file.
- Search upward for the language's `roots`.
- Choose the topmost match without crossing the workspace root.
- Use project-local `workspace-lsp-roots` to stop earlier in nested projects.
- Apply `required-root-patterns` afterward as server-start validation, not
  root detection.

Use `%{workspace_directory}` when a shell command needs the Helix workspace
root. Do not substitute an inferred language-server root.
