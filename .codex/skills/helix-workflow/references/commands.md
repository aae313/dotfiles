# Helix command catalogs

## Contents

- [Authoritative catalogs](#authoritative-catalogs)
- [Typable commands](#typable-commands)
- [Static commands](#static-commands)
- [Lookup procedure](#lookup-procedure)

## Authoritative catalogs

The complete generated catalogs from which this skill was extracted are kept
adjacent to the skill:

- `../../generated/typable-cmd.md`
- `../../generated/static-cmd.md`

Read or search those files whenever an exact command name, alias, argument
contract, or default binding matters. They collectively represent all commands
documented by this Helix source snapshot. Do not substitute a similarly named
command from memory.

## Typable commands

Typable commands begin with `:` and may accept arguments. Important groups:

- File/view lifecycle: `:open`, `:write`, `:quit`, `:buffer-*`, `:new`,
  `:vsplit`, `:hsplit`, `:move`, and force variants.
- Runtime configuration: `:set-option`, `:toggle-option`, `:get-option`,
  `:theme`, `:set-language`, `:config-reload`, and config openers.
- Shell/data flow: `:insert-output`, `:append-output`, `:pipe`, `:pipe-to`,
  `:run-shell-command`, `:read`, `:echo`, and register commands.
- Language tooling: `:format`, `:lsp-*`, tree-sitter inspection, DAP commands,
  and `:yank-diagnostic`.
- Navigation/history: `:goto`, `:earlier`, `:later`, directory stack commands,
  and split commands.
- Diagnostics: `:log-open`, `:character-info`, clipboard provider inspection,
  workspace trust commands, and `:redraw`.

Aliases are part of the public command interface. Prefer descriptive long names
in durable configuration unless the surrounding config consistently uses
aliases.

## Static commands

Static commands take no arguments, can be bound in keymaps, and can be invoked
from the command palette (`Space-?`). The catalog groups naturally into:

- Motion and selection extension.
- Regex search, multi-selection, line, and word operations.
- Mode changes, editing, undo history, registers, and clipboard actions.
- File, buffer, explorer, picker, symbol, diagnostics, and LSP actions.
- Syntax-tree motion, text objects, surrounds, comments, and formatting.
- Jumplist, split/window, scrolling, and view actions.
- DAP actions and shell selection actions.
- Macros, increment/decrement, rename, and jump labels.

Some static commands have no default key binding. They are still valid keymap
targets.

## Lookup procedure

Search exact names first:

```sh
rg -n '^\| `:?(command_name|alias)`' ../../generated
```

Then search descriptions:

```sh
rg -ni 'selection|shell|picker|diagnostic' ../../generated
```

Confirm:

1. Whether the command is typable or static.
2. Whether it accepts arguments.
3. Its aliases and force variant.
4. Its mode-specific default bindings.
5. Whether the requested behavior acts on every selection.
