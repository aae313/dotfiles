use std/clip
use std null_device

def start-zellij []: nothing -> nothing {
    if $env.ZELLIJ? != null {
        return
    }

    if $env.START_ZELLIJ? == "1" {
        zellij
    }
}
start-zellij

$env.config.buffer_editor = "x"
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

let scheme = {
    recognized_command: $theme.blue
    unrecognized_command: $theme.text
    constant: $theme.peach
    punctuation: $theme.overlay2
    operator: $theme.sky
    string: $theme.green
    virtual_text: $theme.surface2
    variable: {fg: $theme.flamingo, attr: i}
    filepath: $theme.yellow
}
$env.config.table.missing_value_symbol = $"(ansi {fg: $theme.red attr: b})nope(ansi reset)"
$env.config.datetime_format.table = null
$env.config.datetime_format.normal = $"(ansi {fg: $theme.blue attr: b})%Y(ansi reset)(ansi $theme.yellow)-(ansi {fg: $theme.blue attr: b})%m(ansi reset)(ansi $theme.yellow)-(ansi {fg: $theme.blue attr: b})%d(ansi reset)(ansi $theme.overlay2)T(ansi {fg: $theme.pink attr: b})%H(ansi reset)(ansi $theme.yellow):(ansi {fg: $theme.pink attr: b})%M(ansi reset)(ansi $theme.yellow):(ansi {fg: $theme.pink attr: b})%S(ansi reset)"
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
$env.FZF_DEFAULT_OPTS = (
  "--multi --highlight-line --cycle --layout=reverse --height=80% " +
  "--highlight-line " +
  "--info=inline-right " +
  "--ansi " +
  "--layout=reverse " +
  "--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 " +
  "--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC " +
  "--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 " +
  "--color=selected-bg:#45475A " +
  "--color=border:#6C7086,label:#CDD6F4"
)

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
            mode: [emacs vi_normal vi_insert]
            event: {
                send: executehostcommand
                cmd: "commandline edit --append (fd --type d | lines | input list --fuzzy 'choose dir:')"
            }
        }
        {
            name: fuzzy_file
            modifier: control
            keycode: char_a
            mode: [emacs vi_normal vi_insert]
            event: {send: executehostcommand, cmd: fuzzy-file-insert}
        }
    ]
}
$env.config.color_config = {
    separator: {fg: $theme.surface2, attr: b}
    leading_trailing_space_bg: {fg: $theme.lavender, attr: u}
    header: {fg: $theme.text, attr: b}
    row_index: $scheme.virtual_text
    record: $theme.text
    list: $theme.text
    hints: $scheme.virtual_text
    search_result: {fg: $theme.base, bg: $theme.yellow}
    shape_closure: $theme.teal
    closure: $theme.teal
    shape_flag: {fg: $theme.maroon, attr: i}
    shape_matching_brackets: {attr: u}
    shape_garbage: $theme.red
    shape_keyword: $theme.mauve
    shape_match_pattern: $theme.green
    shape_signature: $theme.teal
    shape_table: $scheme.punctuation
    cell-path: $scheme.punctuation
    shape_list: $scheme.punctuation
    shape_record: $scheme.punctuation
    shape_vardecl: $scheme.variable
    shape_variable: $scheme.variable
    empty: {attr: n}
    filesize: {|| if $in < 1kb {
        $theme.teal
    } else if $in < 10kb {
        $theme.green
    } else if $in < 100kb {
        $theme.yellow
    } else if $in < 10mb {
        $theme.peach
    } else if $in < 100mb {
        $theme.maroon
    } else if $in < 1gb {
        $theme.red
    } else {
        $theme.mauve
    } }
    duration: {|| if $in < 1day {
        $theme.teal
    } else if $in < 1wk {
        $theme.green
    } else if $in < 4wk {
        $theme.yellow
    } else if $in < 12wk {
        $theme.peach
    } else if $in < 24wk {
        $theme.maroon
    } else if $in < 52wk {
        $theme.red
    } else {
        $theme.mauve
    } }
    datetime: {|| (date now) - $in
    | if $in < 1day {
        $theme.teal
    } else if $in < 1wk {
        $theme.green
    } else if $in < 4wk {
        $theme.yellow
    } else if $in < 12wk {
        $theme.peach
    } else if $in < 24wk {
        $theme.maroon
    } else if $in < 52wk {
        $theme.red
    } else {
        $theme.mauve
    } }
    shape_external: $scheme.unrecognized_command
    shape_internalcall: $scheme.recognized_command
    shape_external_resolved: $scheme.recognized_command
    shape_block: $scheme.recognized_command
    block: $scheme.recognized_command
    shape_custom: $theme.pink
    custom: $theme.pink
    background: $theme.base
    foreground: $theme.text
    cursor: {bg: $theme.rosewater, fg: $theme.base}
    shape_range: $scheme.operator
    range: $scheme.operator
    shape_pipe: $scheme.operator
    shape_operator: $scheme.operator
    shape_redirection: $scheme.operator
    glob: $scheme.filepath
    shape_directory: $scheme.filepath
    shape_filepath: $scheme.filepath
    shape_glob_interpolation: $scheme.filepath
    shape_globpattern: $scheme.filepath
    shape_int: $scheme.constant
    int: $scheme.constant
    bool: $scheme.constant
    float: $scheme.constant
    "nothing": $scheme.constant
    binary: $scheme.constant
    shape_nothing: $scheme.constant
    shape_bool: $scheme.constant
    shape_float: $scheme.constant
    shape_binary: $scheme.constant
    shape_datetime: $scheme.constant
    shape_literal: $scheme.constant
    string: $scheme.string
    shape_string: $scheme.string
    shape_string_interpolation: $theme.flamingo
    shape_raw_string: $scheme.string
    shape_externalarg: $scheme.string
}
$env.config.highlight_resolved_externals = true
$env.config.explore = {
    status_bar_background: {fg: $theme.text, bg: $theme.mantle}
    command_bar_text: {fg: $theme.text}
    highlight: {fg: $theme.base, bg: $theme.yellow}
    status: {error: $theme.red, warn: $theme.yellow, info: $theme.blue}
    selected_cell: {bg: $theme.blue, fg: $theme.base}
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
source ./prompt.nu
$env.config.color_config.string = {|| if $in =~ "^(#|0x)[a-fA-F0-9]+$" {
    $in | str replace "0x" "#"
} else {
    $theme.blue
} }
$env.config.color_config.row_index = $theme.overlay2
$env.config.color_config.header = {
    fg: $theme.teal
    attr: b
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
            description_mode: prefer_right
            min_description_width: 0
            max_description_width: 50
            max_description_height: 10
            description_offset: 1
            correct_cursor_pos: true
        }
        style: {
            text: $theme.text
            selected_text: {fg: $theme.text, bg: $theme.surface1}
            description_text: $theme.overlay2
            match_text: {fg: $theme.sky, attr: u}
            selected_match_text: {fg: $theme.teal, bg: $theme.surface1, attr: u}
        }
    }
    {
        name: history_menu
        only_buffer_difference: true
        marker: $env.PROMPT_INDICATOR
        type: {layout: list, page_size: 10}
        style: {
            text: $theme.text
            selected_text: {fg: $theme.text, bg: $theme.surface1}
        }
    }
]
$env.config.menus = $env.config.menus | where name not-in ($menus | get name) | append $menus
overlay use ./commands.nu

use std/config *

# Initialize the PWD hook as an empty list if it doesn't exist
$env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []

$env.config.hooks.env_change.PWD ++= [{||
  if (which direnv | is-empty) {
    # If direnv isn't installed, do nothing
    return
  }

  direnv export json | from json | default {} | load-env
  # If direnv changes the PATH, it will become a string and we need to re-convert it to a list
  $env.PATH = do (env-conversions).path.from_string $env.PATH
}]
