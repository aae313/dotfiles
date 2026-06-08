          do --env {
            use std null_device

            let theme = {
              rosewater: "#f5e0dc"
              flamingo: "#f2cdcd"
              pink: "#f5c2e7"
              mauve: "#cba6f7"
              red: "#f38ba8"
              maroon: "#eba0ac"
              peach: "#fab387"
              yellow: "#f9e2af"
              green: "#a6e3a1"
              teal: "#94e2d5"
              sky: "#89dceb"
              sapphire: "#74c7ec"
              blue: "#89b4fa"
              lavender: "#b4befe"
              text: "#cdd6f4"
              subtext1: "#bac2de"
              subtext0: "#a6adc8"
              overlay2: "#9399b2"
              overlay1: "#7f849c"
              overlay0: "#6c7086"
              surface2: "#585b70"
              surface1: "#45475a"
              surface0: "#313244"
              base: "#1e1e2e"
              mantle: "#181825"
              crust: "#11111b"
            }

            def prompt-header [
              --left-char: string = ┏
            ]: nothing -> string {
              let code = $env.LAST_EXIT_CODE

              let jj_workspace_root = try {
                jj workspace root err> $null_device
              } catch {
                ""
              }

              let hostname = if ($env.SSH_CONNECTION? | is-not-empty) {
                let hostname = try {
                  sys host | get hostname
                } catch {
                  "remote"
                }

                $"(ansi {fg: $theme.green attr: b})@($hostname)(ansi reset) "
              } else {
                ""
              }

              let body = if ($jj_workspace_root | is-not-empty) {
                let subpath = pwd | path relative-to $jj_workspace_root
                let subpath = if ($subpath | is-not-empty) {
                  $"(ansi {fg: $theme.mauve attr: b}) → (ansi reset)(ansi $theme.blue)($subpath)"
                }

                $"($hostname)(ansi {fg: $theme.yellow attr: b})($jj_workspace_root | path basename)($subpath)(ansi reset)"
              } else {
                $"($hostname)(ansi $theme.teal)(
                  if (pwd | str starts-with $env.HOME) {
                    "~" | path join (pwd | path relative-to $env.HOME)
                  } else {
                    pwd
                  }
                )(ansi reset)"
              }

              let command_duration = ($env.CMD_DURATION_MS | into int) * 1ms
              let command_duration = if $command_duration <= 2sec {
                ""
              } else {
                $"┫(ansi {fg: $theme.pink attr: b})($command_duration)(ansi {fg: $theme.yellow attr: b})┣━"
              }

              let exit_code = if $code == 0 {
                ""
              } else {
                $"┫(ansi {fg: $theme.red attr: b})($code)(ansi {fg: $theme.yellow attr: b})┣━"
              }

              let middle = if $command_duration == "" and $exit_code == "" {
                "━"
              } else {
                ""
              }

              $"(ansi {fg: $theme.yellow attr: b})($left_char)($exit_code)($middle)($command_duration)(ansi reset) ($body)(char newline)"
            }

            $env.PROMPT_INDICATOR = $"(ansi {fg: $theme.yellow attr: b})┃(ansi reset) "
            $env.PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR
            $env.PROMPT_INDICATOR_VI_INSERT = $env.PROMPT_INDICATOR
            $env.PROMPT_MULTILINE_INDICATOR = $env.PROMPT_INDICATOR
            $env.PROMPT_COMMAND = {||
              prompt-header --left-char ┏
            }
            $env.PROMPT_COMMAND_RIGHT = {||
              try {
                jj --quiet --color always --ignore-working-copy log --no-graph --revisions @ --template '
                  separate(
                    " ",
                    if(empty, label("empty", "(empty)")),
                    coalesce(
                      surround(
                        "\"",
                        "\"",
                        if(
                          description.first_line().substr(0, 24).starts_with(description.first_line()),
                          description.first_line().substr(0, 24),
                          description.first_line().substr(0, 23) ++ "…"
                        )
                      ),
                      label(if(empty, "empty"), description_placeholder)
                    ),
                    bookmarks.join(", "),
                    change_id.shortest(),
                    commit_id.shortest(),
                    if(conflict, label("conflict", "(conflict)")),
                    if(divergent, label("divergent prefix", "(divergent)")),
                    if(hidden, label("hidden prefix", "(hidden)")),
                  )
                ' err> $null_device
              } catch {
                ""
              }
            }

            $env.TRANSIENT_PROMPT_INDICATOR = "  "
            $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = $env.TRANSIENT_PROMPT_INDICATOR
            $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = $env.TRANSIENT_PROMPT_INDICATOR
            $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = $env.TRANSIENT_PROMPT_INDICATOR
            $env.TRANSIENT_PROMPT_COMMAND = {||
              prompt-header --left-char ━
            }
            $env.TRANSIENT_PROMPT_COMMAND_RIGHT = $env.PROMPT_COMMAND_RIGHT
          }
