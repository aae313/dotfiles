# Helix editing context

## Contents

- [Selections](#selections)
- [Registers](#registers)
- [Pickers](#pickers)
- [Syntax-aware operations](#syntax-aware-operations)
- [Surrounds and jumps](#surrounds-and-jumps)

## Selections

Helix commands act on selections. A workflow must specify how the selection is
created and whether it supports multiple selections.

- `%` selects the document.
- `s` selects regex matches inside selections.
- `S` splits selections on regex matches.
- `Alt-s` splits on newlines.
- `K` keeps matching selections; `Alt-K` removes matching selections.
- `,` keeps the primary selection.
- `)` and `(` rotate the primary selection.

Selection-backed shell commands process each selection. Do not assume that
primary-selection expansions such as `%{selection}` represent all selections.

## Registers

Prefix an operation with `"` and a register name. Default registers include:

| Register | Value |
| --- | --- |
| `/` | Last search |
| `:` | Last executed command |
| `"` | Last yanked text |
| `@` | Last recorded macro |

Special registers include:

| Register | Behavior |
| --- | --- |
| `_` | Discard writes; return no values |
| `#` | Selection indices, read-only |
| `.` | Current selection contents, read-only |
| `%` | Current file name, read-only |
| `+` | System clipboard |
| `*` | Primary clipboard |

Clipboard yanks join multiple selections with newlines. Pasting can restore
multiple selections when the same Helix session produced the clipboard value.

## Pickers

Most picker filters use fzf-style syntax. Global search uses regex, and
workspace symbol search delegates terms to the language server. OR (`|`) is
not supported in picker filters.

Prefix a multi-column filter with a column name such as `%path`; unique
prefixes such as `%p` and `%pa` work. Insert a register with `Ctrl-r` followed
by its name. Global search uses the search register when submitted empty.

`Space-e` opens the workspace-rooted file explorer. `Space-.` opens one rooted
at the current buffer directory. File explorer ignore defaults differ from
file picker and global search defaults.

## Syntax-aware operations

`Alt-o` expands to a parent syntax node, `Alt-i` shrinks, and `Alt-n`/`Alt-p`
select sibling nodes. These require an active tree-sitter grammar.

Use `mi` and `ma` for inner and around text objects. Tree-sitter-backed objects
include function, type, argument, comment, test, change, and HTML element.
Their availability depends on language query files.

Use `:tree-sitter-subtree` to inspect the syntax tree spanning the primary
selection when designing syntax-aware behavior.

## Surrounds and jumps

`ms<char>` adds, `mr<old><new>` replaces, and `md<char>` deletes surrounds.
Surrounds support counts and multiple selections.

Helix stores locations and selections in its jumplist. `Ctrl-s` saves a jump,
`Ctrl-o` moves backward, `Ctrl-i` moves forward, and `Space-j` opens the
jumplist picker. Buffer switches, pickers, global search, large motions, and
definition/reference navigation commonly add jumps.
