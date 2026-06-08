# Zellij integration: floating-pane respawn and keystroke injection.
# Exported names must not collide with zellij CLI subcommands invoked through
# this module's importers (`run`, `action`), or those calls would be shadowed.

# Re-run a script inside a new floating pane of the current zellij session.
export def respawn-floating [opts: record<script: string, args: list<string>, cwd: string, name: string>]: nothing -> nothing {
  let result = zellij run -c -f --cwd $opts.cwd -x 10% -y 10% --width 80% --height 80% --name $opts.name "--" nu $opts.script ...$opts.args | complete
  if $result.exit_code != 0 {
    error make {msg: $"zellij run failed: ($result.stderr | str trim)"}
  }
}

# Toggle floating panes, e.g. to hand focus back to the tiled Helix pane.
export def toggle-floating []: nothing -> nothing {
  zellij action toggle-floating-panes
}

# Send a single key (ASCII code) to a pane (the focused one unless --pane).
export def write-key [code: int, --pane: string = ""]: nothing -> nothing {
  if $pane == "" {
    zellij action write $code
  } else {
    zellij action write -p $pane $code
  }
}

# Type a string of characters into a pane (the focused one unless --pane).
export def write-chars [chars: string, --pane: string = ""]: nothing -> nothing {
  if $pane == "" {
    zellij action write-chars $chars
  } else {
    zellij action write-chars -p $pane $chars
  }
}
