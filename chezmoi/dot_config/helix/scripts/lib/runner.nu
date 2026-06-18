# Pipeline driver: project root -> floating-pane respawn -> find -> pick -> jump.
# Returns the exit code so entry scripts keep `exit` in main.

use zellij.nu
use helix.nu
use picker.nu

# Workspace root of the surrounding jj repo, falling back to the cwd.
export def project-root []: nothing -> string {
  let result = jj workspace root | complete
  if $result.exit_code == 0 { $result.stdout | str trim } else { pwd }
}

# Run a tool spec through the pipeline; returns the exit code for main.
export def run [
  spec: record<script: string, args: list<string>, pane_name: string, prompt: string, empty_message: string, finder: closure>
  --picker
  --target-pane: string = ""
]: nothing -> int {
  let root = project-root

  if ($env.ZELLIJ_PANE_ID? != null) and (not $picker) {
    let args = $spec.args ++ ["--picker" "--target-pane" $env.ZELLIJ_PANE_ID]
    zellij respawn-floating {script: $spec.script, args: $args, cwd: $root, name: $spec.pane_name}
    return 0
  }

  let matches = do $spec.finder $root
  if ($matches | is-empty) {
    print --stderr $spec.empty_message
    if $picker { sleep 3sec }
    return 1
  }

  let picked = $matches | picker pick $spec.prompt
  if $picked == null {
    return 0
  }

  print $"($picked.file):($picked.line):($picked.col)"

  if $target_pane != "" {
    helix jump $target_pane $picked
  }
  0
}
