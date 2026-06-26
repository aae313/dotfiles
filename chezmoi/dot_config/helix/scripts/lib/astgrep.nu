# ast-grep finder backend: structural search producing location tables
# of record<file: string, line: int, col: int, code: string>.

# Check that a name is a bare C/Rust identifier, safe to splice into patterns.
export def is-identifier [name: string]: nothing -> bool {
  $name =~ '^[A-Za-z_][A-Za-z0-9_]*$'
}

# Sub-rules matching every call form of a named function in the language.
export def call-patterns [lang: string, name: string]: nothing -> list {
  if $lang == c {
    # A bare `name($$$)` pattern is ambiguous in C (parses as a declaration),
    # so anchor it as a statement and select the call inside.
    [
      {pattern: {context: ($name + "($$$ARGS);"), selector: call_expression}}
    ]
  } else {
    [
      {pattern: ($name + "($$$ARGS)")}
      {pattern: ("$PATH::" + $name + "($$$ARGS)")}
      {pattern: ("$RECV." + $name + "($$$ARGS)")}
      {pattern: ($name + "::<$$$GEN>($$$ARGS)")}
      {pattern: ("$PATH::" + $name + "::<$$$GEN>($$$ARGS)")}
      {pattern: ("$RECV." + $name + "::<$$$GEN>($$$ARGS)")}
    ]
  }
}

# Scan the piped-in root directory with sub-rules (combined as any-of).
export def scan [lang: string, ...rules: record]: string -> table {
  let root = $in
  let inline = {
    id: search
    language: $lang
    rule: {any: $rules}
  } | to yaml
  let result = ast-grep scan --inline-rules $inline --json=stream $root | complete
  if $result.exit_code != 0 {
    error make {
      msg: $"ast-grep failed with exit code ($result.exit_code): ($result.stderr | str trim)"
    }
  }
  $result.stdout | lines | each {|raw|
    let m = try { $raw | from json } catch {
      error make {msg: $"unexpected ast-grep output line: ($raw)"}
    }
    {
      file: $m.file
      line: ($m.range.start.line + 1)
      col: ($m.range.start.column + 1)
      code: ($m.lines | str replace --all --regex \s+ ' ' | str trim)
    }
  }
}
