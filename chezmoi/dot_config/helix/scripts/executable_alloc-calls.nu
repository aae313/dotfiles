#!/usr/bin/env nu

# Find C allocator call-sites (malloc/calloc/realloc/free) and jump Helix
# to the picked one.

use lib/runner.nu
use lib/astgrep.nu

const SCRIPT = path self
const ALLOC_FUNCS = [malloc calloc realloc free]

def main [
  --picker                    # internal: run the picker in this terminal
  --target-pane: string = ""  # internal: zellij pane id of the helix instance
]: nothing -> nothing {
  let rules = $ALLOC_FUNCS | each {|name| astgrep call-patterns c $name } | flatten
  let spec = {
    script: $SCRIPT
    args: []
    pane_name: alloc-calls
    prompt: "alloc → "
    empty_message: "no allocator calls found"
    finder: {|root| $root | astgrep scan c ...$rules }
  }
  exit (runner run $spec --picker=$picker --target-pane $target_pane)
}
