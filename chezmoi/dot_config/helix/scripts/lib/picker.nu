# fzf picker: choose one location from a table; null when cancelled or unmatched.

# Pick one location from the piped-in table via fzf; null when cancelled.
export def pick [prompt: string]: [
  table -> record
  table -> nothing
] {
  let lines = $in
    | each {|m| $"($m.file)\t($m.line)\t($m.col)\t($m.code)" }
    | str join "\n"
  let fzf_args = [
    "--delimiter" "\t"
    "--with-nth" "{1}:{2}: {4}"
    "--prompt" $prompt
    "--preview" "bat --color=always --style=numbers --highlight-line {2} {1}"
    "--preview-window" "up,60%,border-bottom,+{2}/2"
  ]
  let result = $lines | fzf ...$fzf_args | complete
  match $result.exit_code {
    0 => {
      let fields = $result.stdout | str trim | split row "\t"
      if ($fields | length) < 3 {
        error make {msg: $"unexpected fzf selection: ($result.stdout)"}
      }
      {
        file: $fields.0?
        line: ($fields.1? | into int)
        col: ($fields.2? | into int)
      }
    }
    # 1 = no match, 130 = cancelled
    1 | 130 => null
    _ => {
      error make {
        msg: $"fzf failed with exit code ($result.exit_code): ($result.stderr | str trim)"
      }
    }
  }
}
