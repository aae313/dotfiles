use std/clip
use std null_device

def start_zellij [] {
  if $env.ZELLIJ? != null {
    return
  }

  if $env.START_ZELLIJ? == "1" {
    zellij
  }
}

start_zellij

$env.config.buffer_editor = "hx"
$env.config.history.file_format = "sqlite"
$env.config.history.isolation = false
$env.config.history.max_size = 10_000_000
$env.config.history.sync_on_enter = true
$env.config.show_banner = false
$env.config.rm.always_trash = false
$env.config.recursion_limit = 100
$env.config.edit_mode = "vi"
$env.config.cursor_shape.emacs = "line"
$env.config.cursor_shape.vi_insert = "line"
$env.config.cursor_shape.vi_normal = "block"
$env.config.use_kitty_protocol = true
$env.config.shell_integration.osc2 = true
$env.config.shell_integration.osc7 = true
$env.config.shell_integration.osc8 = true
$env.config.shell_integration.osc9_9 = true
$env.config.shell_integration.osc133 = true
$env.config.shell_integration.osc633 = true
$env.config.shell_integration.reset_application_mode = true
$env.config.bracketed_paste = true
$env.config.use_ansi_coloring = "auto"
$env.config.error_style = "fancy"
$env.config.highlight_resolved_externals = true
$env.config.display_errors.exit_code = false
$env.config.display_errors.termination_signal = true
$env.config.footer_mode = 25
$env.config.table.mode = "single"
$env.config.table.index_mode = "always"
$env.config.table.show_empty = true
$env.config.table.padding.left = 1
$env.config.table.padding.right = 1
$env.config.table.trim.methodology = "wrapping"
$env.config.table.trim.wrapping_try_keep_words = true
$env.config.table.trim.truncating_suffix = "..."
$env.config.table.header_on_separator = true
$env.config.table.abbreviated_row_count = null
$env.config.table.footer_inheritance = true
let modus = {
    fg_main: "#ffffff"
    fg_dim: "#989898"
    red: "#ff5f59"
    green_cooler: "#11c777"
    yellow: "#d0bc00"
    blue: "#2fafff"
    blue_cooler: "#00bcff"
    blue_warmer: "#79a8ff"
    magenta_warmer: "#f78fe7"
    magenta_cooler: "#b6a0ff"
    cyan_warmer: "#4ae2f0"
    bg_completion: "#483d8a"
}
$env.config.table.missing_value_symbol = $"(ansi {fg: $modus.red attr: b})nope(ansi reset)"
$env.config.datetime_format.table = null
$env.config.datetime_format.normal = $"(ansi {fg: $modus.blue attr: b})%Y(ansi reset)(ansi $modus.yellow)-(ansi {fg: $modus.blue attr: b})%m(ansi reset)(ansi $modus.yellow)-(ansi {fg: $modus.blue attr: b})%d(ansi reset)(ansi $modus.fg_dim)T(ansi {fg: $modus.magenta_warmer attr: b})%H(ansi reset)(ansi $modus.yellow):(ansi {fg: $modus.magenta_warmer attr: b})%M(ansi reset)(ansi $modus.yellow):(ansi {fg: $modus.magenta_warmer attr: b})%S(ansi reset)"
$env.config.filesize.unit = "metric"
$env.config.filesize.show_unit = true
$env.config.filesize.precision = 1
$env.config.render_right_prompt_on_last_line = false
$env.config.float_precision = 2
$env.config.ls.use_ls_colors = true
$env.LS_COLORS = (open --raw ($nu.config-path | path dirname | path join ls_colors.txt) | str trim)
$env.config.hooks.pre_execution = $env.config?.hooks?.pre_execution? | default [] | append [
    {||
        commandline | str trim | if ($in | is-not-empty) { print $"(ansi title)($in) — nu(char bel)" }
    }
]
$env.config.hooks.display_output = {||
    tee { table --expand | print } | try {
        # SQLiteDatabase doesn't support equality comparisions
        if $in != null { $env.last = $in }
    }
}
$env.FZF_DEFAULT_OPTS = "--highlight-line --cycle --layout=reverse --height=80% --color=fg:#ffffff,fg+:#ffffff,bg+:#483d8a,hl:#00bcff,hl+:#4ae2f0,prompt:#4ae2f0,pointer:#f78fe7,marker:#11c777,spinner:#d0bc00,header:#989898 --bind=tab:down,btab:up,ctrl-space:toggle"
$env.config.completions.algorithm = "substring"
$env.config.completions.sort = "smart"
$env.config.completions.case_sensitive = false
$env.config.completions.quick = true
$env.config.completions.partial = true
$env.config.completions.use_ls_colors = true
$env.config = {
    keybindings: [
        {
            name: fuzzy_dir
            modifier: control
            keycode: char_s
            mode: [emacs, vi_normal, vi_insert]
            event: {send: executehostcommand, cmd: "commandline edit --append (fd --type d | lines | input list --fuzzy 'choose dir:')"}
        }
        {
            name: fuzzy_file
            modifier: control
            keycode: char_a
            mode: [emacs, vi_normal, vi_insert]
            event: {send: executehostcommand, cmd: fuzzy-file-insert}
        }
    ]
}
def fuzzy-file-insert [] {
    let sel = fd --type f | lines | input list --fuzzy 'choose file:'
    if $sel != null {
        commandline edit --append $'($sel) '
    }
}
$env.CARAPACE_BRIDGES = 'fish'
source ~/.cache/carapace/init.nu
source ./zoxide.nu
$env.config.color_config.string = {|| if $in =~ "^(#|0x)[a-fA-F0-9]+$" {
    $in | str replace "0x" "#"
} else {
    $modus.blue
} }
$env.config.color_config.row_index = $modus.fg_dim
$env.config.color_config.header = {
    fg: $modus.cyan_warmer
    attr: b
}
do --env {
    def prompt-header [--left-char: string]: nothing -> string {
        let code = $env.LAST_EXIT_CODE
        let jj_workspace_root = try {
            jj workspace root err> $null_device
        } catch {
            ""
        }
        let hostname = if ($env.SSH_CONNECTION? | is-not-empty) {
            let hostname = try {
                hostname
            } catch {
                "remote"
            }
            $"(ansi {fg: $modus.green_cooler attr: b})@($hostname)(ansi reset) "
        } else {
            ""
        }
        # https://github.com/nushell/nushell/issues/16205
        #
        # Case insensitive filesystems strike again!
        let pwd = pwd | path expand
        let body = if ($jj_workspace_root | is-not-empty) {
            let subpath = $pwd | path relative-to $jj_workspace_root
            let subpath = if ($subpath | is-not-empty) {
                $"(ansi {fg: $modus.magenta_cooler attr: b}) → (ansi reset)(ansi $modus.blue_warmer)($subpath)"
            }
            $"($hostname)(ansi {fg: $modus.cyan_warmer attr: b})($jj_workspace_root | path basename)($subpath)(ansi reset)"
        } else {
            let pwd = if ($pwd | str starts-with $env.HOME) {
                "~" | path join ($pwd | path relative-to $env.HOME)
            } else {
                $pwd
            }
            $"($hostname)(ansi $modus.blue_warmer)($pwd)(ansi reset)"
        }
        let command_duration = ($env.CMD_DURATION_MS | into int) * 1ms
        let command_duration = if $command_duration <= 2sec {
            ""
        } else {
            $"┫(ansi {fg: $modus.magenta_warmer attr: b})($command_duration)(ansi {fg: $modus.cyan_warmer attr: b})┣━"
        }
        let exit_code = if $code == 0 {
            ""
        } else {
            $"┫(ansi {fg: $modus.red attr: b})($code)(ansi {fg: $modus.cyan_warmer attr: b})┣━"
        }
        let middle = if $command_duration == "" and $exit_code == "" {
            "━"
        } else {
            ""
        }
        $"(ansi {fg: $modus.cyan_warmer attr: b})($left_char)($exit_code)($middle)($command_duration)(ansi reset) ($body)(char newline)"
    }
    $env.PROMPT_INDICATOR = $"(ansi {fg: $modus.cyan_warmer attr: b})┃  (ansi reset) "
    $env.PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR
    $env.PROMPT_INDICATOR_VI_INSERT = $env.PROMPT_INDICATOR
    $env.PROMPT_MULTILINE_INDICATOR = $env.PROMPT_INDICATOR
    $env.PROMPT_COMMAND = {|| prompt-header --left-char "┏" }
    $env.PROMPT_COMMAND_RIGHT = {||
        let jj_status = try {
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
        $jj_status
    }
    $env.TRANSIENT_PROMPT_INDICATOR = "  "
    $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = $env.TRANSIENT_PROMPT_INDICATOR
    $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = $env.TRANSIENT_PROMPT_INDICATOR
    $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = $env.TRANSIENT_PROMPT_INDICATOR
    $env.TRANSIENT_PROMPT_COMMAND = {|| prompt-header --left-char "━" }
    $env.TRANSIENT_PROMPT_COMMAND_RIGHT = $env.PROMPT_COMMAND_RIGHT
}
let menus = [
    {
        name: completion_menu
        only_buffer_difference: false
        marker: $env.PROMPT_INDICATOR
        type: {
            layout: ide
            min_completion_width: 0
            max_completion_width: 150
            max_completion_height: 25
            padding: 0
            border: false
            cursor_offset: 0
            description_mode: "prefer_right"
            min_description_width: 0
            max_description_width: 50
            max_description_height: 10
            description_offset: 1
            correct_cursor_pos: true
        }
        style: {
            text: $modus.fg_main
            selected_text: {
                fg: $modus.fg_main
                bg: $modus.bg_completion
            }
            description_text: $modus.fg_dim
            match_text: {
                fg: $modus.blue_cooler
                attr: u
            }
            selected_match_text: {
                fg: $modus.cyan_warmer
                bg: $modus.bg_completion
                attr: u
            }
        }
    }
    {
        name: history_menu
        only_buffer_difference: true
        marker: $env.PROMPT_INDICATOR
        type: {layout: list, page_size: 10}
        style: {
            text: $modus.fg_main
            selected_text: {
                fg: $modus.fg_main
                bg: $modus.bg_completion
            }
        }
    }
]
$env.config.menus = $env.config.menus | where name not-in ($menus | get name) | append $menus
alias l = ls
alias la = ls --all
alias ll = ls --long
alias lla = ls --long --all
alias cp = cp -rv
alias mv = mv -v
alias rm = rm -rvft
alias cat = bat
alias n = hx
alias e = hx
alias x = hx .
alias j = just
alias calc = numbat --pretty-print=always -e
alias xc = chezmoi edit --verbose --apply
alias py = python
alias wl = wl-copy
alias che = chezmoi
alias apply = chezmoi apply --verbose
def _ []: nothing -> any { $env.last? }
def --env mc [path: path]: nothing -> nothing {
    mkdir $path
    cd $path
}
def --env mcg [path: path]: nothing -> nothing {
    mkdir $path
    cd $path
    jj git init
}
def jjc []: nothing -> nothing {
    let timestamp = date now | format date "%Y-%m-%dT%H:%M:%S%.3f%:z"
    let extra = input "Details: " | str trim
    let message = if ($extra | is-empty) {
        $timestamp
    } else {
        $"($timestamp): ($extra)"
    }

    jj --no-pager commit --message $message
    if $env.LAST_EXIT_CODE == 0 {
        jj --no-pager bookmark move main --to @-
    }
}
def --env "nu-complete jc" [commandline: string] {
    let stor = stor open
    # FIXME
    if $stor.jc_completions? == null {
        stor create --table-name jc_completions --columns { value: str, description: str, is_flag: bool }
    }
    if $stor.jc_completions_ran? == null {
        stor create --table-name jc_completions_ran --columns { _: bool }
    }
    if $stor.jc_completions_ran == [] {
        try {
            let about = ^jc --about | from json
            let magic = $about | get parsers | each { { value: $in.magic_commands?, description: $in.description } } | where value != null | flatten
            let options = $about | get parsers | select argument description | rename value description
            let inherent = ^jc --help | lines | split list "" | where { $in.0? == "Options:" } | get 0 | skip 1 | each { str trim } | parse "{short},  {long} {description}" | update description { str trim } | each {|record|
        [[value, description];
          [$record.short, $record.description],
          [$record.long, $record.description],
        ]
      } | flatten
            for entry in $magic {
                stor insert --table-name jc_completions --data-record ($entry | insert is_flag false)
            }
            for entry in ($options ++ $inherent) {
                stor insert --table-name jc_completions --data-record ($entry | insert is_flag true)
            }
            stor insert --table-name jc_completions_ran --data-record { _: true }
        }
    }
    if ($commandline | str contains "-") {
        $stor.jc_completions
    } else {
        $stor.jc_completions | where is_flag == 0
    } | select value description
}
def --wrapped jc [...arguments: string@"nu-complete jc"]: any -> table, any -> record, any -> string {
    let run = ^jc ...$arguments | complete
    if $run.exit_code != 0 {
        error make {
            msg: "jc exection failed"
            label: {
                text: ($run.stderr | str replace "jc:" "" | str replace "Error -" "" | str trim)
                span: (metadata $arguments).span
            }
        }
    }
    if "--help" in $arguments or "-h" in $arguments {
        $run.stdout
    } else {
        $run.stdout | from json
    }
}
