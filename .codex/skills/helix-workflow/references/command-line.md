# Helix command line

This is the primary reference for composing typable commands and shell-backed
workflows.

## Contents

- [Normal parsing](#normal-parsing)
- [Flags](#flags)
- [Expansions](#expansions)
- [Shell-command exceptions](#shell-command-exceptions)
- [Typed command exceptions](#typed-command-exceptions)
- [Selection-aware shell commands](#selection-aware-shell-commands)
- [Checklist](#checklist)

## Normal parsing

Press `:` to enter command mode. Helix normally splits arguments on spaces and
tabs.

- Protect spaces with single quotes, backticks, or double quotes.
- Single quotes and backticks are literal.
- Double quotes protect spaces and allow Helix expansions.
- On Unix, backslash can escape whitespace, quote characters, or an initial
  percent token. It is otherwise literal. On Windows it is always literal.

Examples:

```text
:open README.md CHANGELOG.md
:open 'notes/a b.txt'
:echo "%{buffer_name}:%{cursor_line}"
:echo '%{cursor_line}'
:echo \%sh{literal}
```

The third command expands editor values. The fourth prints the token literally.

## Flags

Commands may accept long and short flags. Typing `-` offers completions when
the command exposes flags. `--` ends flag parsing:

```text
:sort --reverse
:open -- -a.txt
```

## Expansions

Expansions have the form `%[kind]<open>contents<close>`. Valid delimiter pairs
are `()`, `[]`, `{}`, and `<>`; single delimiters `'`, `"`, and `|` also work.
Helix evaluates expansions when Enter is pressed.

### Variables

An omitted kind means an editor variable:

| Variable | Value |
| --- | --- |
| `cursor_line` | One-based primary cursor line |
| `cursor_column` | One-based grapheme-cluster column |
| `buffer_name` | Relative focused-buffer path, or `[scratch]` |
| `file_path_absolute` | Absolute focused-buffer path; current directory for scratch buffers |
| `line_ending` | Current document line-ending string |
| `current_working_directory` | Current working directory |
| `workspace_directory` | Nearest ancestor containing `.git`, `.svn`, `.jj`, or `.helix` |
| `language` | Current language name |
| `selection` | Primary selection text |
| `selection_line_start` | One-based primary-selection start line |
| `selection_line_end` | One-based primary-selection end line |

Example:

```text
:echo "%{file_path_absolute}:%{cursor_line}"
```

### Expansion kinds

- `%u{25CF}` inserts a Unicode codepoint, with at most six hexadecimal digits.
- `%sh{command}` executes text using `editor.shell` and inserts stdout.
- `%reg{a}` inserts the contents of register `a`.
- Expansions are recursive: variables inside `%sh{...}` are expanded before
  the shell command runs.

Use `%%` for a literal percent inside an expansion:

```text
:echo %sh{date -u +'%%Y-%%m-%%d'}
```

## Shell-command exceptions

These commands expand Helix expansions but otherwise pass their argument
directly to the configured shell:

- `:insert-output`
- `:append-output`
- `:pipe`
- `:pipe-to`
- `:run-shell-command`

Normal Helix quote parsing does not occur after the command name. For example:

```text
:sh echo "%{buffer_name}:%{cursor_column}"
```

Helix substitutes the variables, then gives the quote characters and remaining
text to `editor.shell`. Design quoting for that shell.

## Typed command exceptions

`:set-option` parses the option name normally. String values consume the
remaining text; other values are JSON.

`:toggle-option` depends on the option type:

- Boolean: provide only the option name.
- String: provide a normally quoted cycle of values.
- Number, array, or object: provide a stream of JSON values.
- Repeated cycle values are removed.

Examples:

```text
:set search.smart-case false
:toggle auto-format
:toggle indent-heuristic hybrid tree-sitter simple
:toggle rulers [81] [51, 73]
```

`:lsp-workspace-command` parses its optional first argument normally and the
rest as JSON. String command arguments must be quoted:

```text
:lsp-workspace-command lsp.Command "foo" "bar"
```

## Selection-aware shell commands

| Typable command | Static command | Behavior |
| --- | --- | --- |
| `:pipe` / `:\|` | `shell_pipe` (`\|`) | Send each selection to stdin and replace it with stdout |
| `:pipe-to` | `shell_pipe_to` (`Alt-\|`) | Send each selection to stdin and ignore stdout |
| `:insert-output` | `shell_insert_output` (`!`) | Insert stdout before each selection |
| `:append-output` | `shell_append_output` (`Alt-!`) | Append stdout after each selection |
| `:run-shell-command` / `:sh` / `:!` | — | Run a shell command |
| — | `shell_keep_pipe` (`$`) | Keep selections for which the shell predicate succeeds |

These actions operate on selections, not necessarily on the entire buffer.
Select the desired ranges explicitly and test multiple selections.

## Checklist

Before emitting a command:

1. Identify which parser owns each quote.
2. Identify whether every selection or only the primary selection is used.
3. Choose a relative or absolute path expansion intentionally.
4. Escape literal percent signs.
5. Confirm `editor.shell`.
6. Decide whether stdout replaces, inserts, appends, or is discarded.
