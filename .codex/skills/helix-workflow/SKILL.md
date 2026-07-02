---
name: helix-workflow
description: Design, implement, and troubleshoot Helix command-driven workflows, configuration, keymaps, shell integration, selections, registers, pickers, formatters, language servers, workspace roots, and the hx CLI. Use when working on Helix config.toml or languages.toml, choosing static versus typable commands, composing selection-aware external commands, or integrating Helix into a terminal workflow.
---

# Helix Workflow

Build Helix-centered workflows from Helix's actual command and selection
semantics. Treat external programs as commands invoked by Helix, not as domains
covered by this skill.

## Work from local truth

1. Run `hx --version` and inspect the user's existing `config.toml`,
   `languages.toml`, and workspace `.helix/` files.
2. Preserve existing keymap organization, shell choice, and project conventions.
3. Check command names against the command catalogs. Do not infer a static
   command name from a typable command or vice versa.
4. Make the smallest configuration change that implements the requested
   workflow.
5. Validate TOML and use `hx --health` for installation, language, grammar,
   clipboard, formatter, or language-server problems.

The bundled references were extracted from the adjacent Helix 25.07.1 book
sources. For a different installed version, prefer that version's `hx --help`,
command palette, and documentation when behavior differs.

## Choose the command surface

- Use a **static command** for a no-argument editor action or key binding.
- Use a **typable command** for a `:` command that accepts arguments.
- Use `:pipe` or `shell_pipe` to replace every selection with command output.
- Use `:pipe-to` or `shell_pipe_to` for a selection-fed side effect that must
  not alter the buffer.
- Use `:insert-output` or `shell_insert_output` to insert command output before
  selections.
- Use `:append-output` or `shell_append_output` to append command output after
  selections.
- Use `:run-shell-command`/`:sh`/`:!` for a shell command that does not consume
  selections through the selection-pipe interface.
- Use a picker for interactive item selection. Picker query syntax is not shell
  syntax.

Read [references/command-line.md](references/command-line.md) before writing
any expansion-heavy or shell-backed command. Read
[references/commands.md](references/commands.md) when choosing command names.

## Compose safely

- Remember that Helix executes external commands through `editor.shell`.
  On Unix the default is `["sh", "-c"]`; the user's interactive shell is
  irrelevant unless configured explicitly.
- Keep editor expansions distinct from shell expansion. Helix evaluates
  `%{...}`, `%sh{...}`, `%reg{...}`, and `%u{...}` before execution.
- Account for the special parsing of shell-backed typable commands: Helix
  expands values but passes the remaining text directly to the configured
  shell without applying normal command-line quote parsing.
- Double literal percent signs inside expansions.
- Prefer `%{file_path_absolute}` over `%{buffer_name}` when a command requires
  an unambiguous filesystem path. Scratch buffers expand differently.
- Treat selections as a list. Pipe commands run once per selection; clipboard
  and register operations may join or preserve multiple values differently.
- Do not route an interactive terminal UI through a selection-transforming
  command. Establish terminal ownership outside Helix when a tool needs it.

Read [references/editing-context.md](references/editing-context.md) for
selections, registers, pickers, syntax-aware operations, and jumps.

## Configure editor integrations

- Put general editor and shell settings in `config.toml`.
- Put language, formatter, language-server, grammar, and per-language settings
  in `languages.toml`.
- Configure a formatter as a stdin-to-stdout process. Use
  `%{buffer_name}` in formatter arguments when the formatter needs a filename.
- Distinguish the workspace root from the LSP root. Workspace discovery uses
  `.git`, `.svn`, `.jj`, or `.helix`; language `roots` and project-local
  `workspace-lsp-roots` control LSP selection.
- Use feature filters and array order deliberately when assigning multiple
  language servers.

Read [references/configuration.md](references/configuration.md) before changing
shell, picker, formatter, language-server, or workspace-root configuration.
Read [references/hx-cli.md](references/hx-cli.md) for process-level commands.

## Verify the result

- Parse or otherwise validate changed TOML.
- Reload configuration with `:config-reload` when supported; restart language
  servers when required.
- Exercise the exact key binding or typable command with paths containing
  spaces and with multiple selections when relevant.
- Check `:log-open` and targeted `hx --health CATEGORY` output when an external
  process fails.
- Report the modified paths and the exact behavior the workflow now provides.
