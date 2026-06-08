#!/usr/bin/env nu

# Find call-sites of a C or Rust function and jump Helix to the picked one.

use lib/runner.nu
use lib/astgrep.nu
use lib/helix.nu

const SCRIPT = path self
const SUPPORTED_LANGS = [c rust]
const USAGE = "usage: function-usages.nu --lang <c|rust> [--selection] [FUNCTION]"

def main [
  name?: string               # function identifier (omit when using --selection)
  --lang: string              # language: c or rust
  --selection                 # read the identifier from stdin (helix :pipe-to)
  --picker                    # internal: run the picker in this terminal
  --target-pane: string = ""  # internal: zellij pane id of the helix instance
]: nothing -> nothing {
  let lang = if $lang != null and $lang in $SUPPORTED_LANGS {
    $lang
  } else {
    print --stderr $"error: --lang must be one of ($SUPPORTED_LANGS | str join ', '), got '($lang | default '')'"
    print --stderr $USAGE
    exit 2
  }

  let name = if $selection {
    if $name != null {
      print --stderr "error: FUNCTION argument and --selection are mutually exclusive"
      print --stderr $USAGE
      exit 2
    }
    try { helix read-piped-selection } catch {
      print --stderr "error: failed to read the selection from stdin"
      exit 2
    }
  } else {
    if $name == null {
      print --stderr "error: missing FUNCTION argument"
      print --stderr $USAGE
      exit 2
    }
    $name
  }

  if not (astgrep is-identifier $name) {
    print --stderr $"error: expected one C/Rust identifier, got '($name)'"
    print --stderr $USAGE
    exit 2
  }

  let spec = {
    script: $SCRIPT
    args: ["--lang" $lang $name]
    pane_name: function-usages
    prompt: $"($name) → "
    empty_message: $"no usages of ($name) found"
    finder: {|root| $root | astgrep scan $lang ...(astgrep call-patterns $lang $name) }
  }
  exit (runner run $spec --picker=$picker --target-pane $target_pane)
}
