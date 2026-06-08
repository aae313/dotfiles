# Helix integration: drive the editor via keystroke injection
# (replace with the Steel plugin API once Helix ships it).

use zellij.nu

def open-command [...files: string]: nothing -> string {
  let quoted = $files | each {|f|
    let escaped = $f | str replace --all --regex '([\\"])' \$1
    $"\"($escaped)\""
  }
  ":open " + ($quoted | str join " ")
}

# Make Helix open the given files (in the focused pane unless --pane).
export def open-files [...files: string, --pane: string = ""]: nothing -> nothing {
  zellij write-key 27 --pane $pane
  zellij write-chars (open-command ...$files) --pane $pane
  zellij write-key 13 --pane $pane
}

# Open a file at line/col in the Helix instance running in the given pane.
export def jump [pane: string, target: record<file: string, line: int, col: int>]: nothing -> nothing {
  open-files $target.file --pane $pane
  let column_motion = if $target.col > 1 { $"(($target.col - 1))l" } else { "" }
  zellij write-chars $"($target.line)gg($column_motion)zz" --pane $pane
}

# Read the editor selection that Helix :pipe-to writes to stdin.
export def read-piped-selection []: nothing -> string {
  let raw = try { open --raw /dev/stdin } catch {
    error make {msg: "failed to read the selection from stdin"}
  }
  $raw | str trim
}
