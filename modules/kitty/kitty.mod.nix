_: {
  flake.nixosModules.kitty =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.attrsets) attrNames mapAttrsToList;
      inherit (lib.lists) subtractLists;
      inherit (lib.meta) getExe;

      inherit (config.local) user;
      inherit (config.local.theme) fonts palette;

      activeBackground = "#${palette.bgMain}";
      inactiveBackground = "#0d0e1c";

      inactiveBgWatcher = pkgs.writeText "kitty-inactive-bg.py" ''
        from typing import Any

        from kitty.boss import Boss
        from kitty.window import Window

        ACTIVE_BG = "${activeBackground}"
        INACTIVE_BG = "${inactiveBackground}"

        def set_background(boss: Boss, window: Window, is_focused: bool) -> None:
            background = ACTIVE_BG if is_focused else INACTIVE_BG
            boss.call_remote_control(
                window,
                ("set-colors", f"--match=id:{window.id}", f"background={background}"),
            )

        def on_focus_change(boss: Boss, window: Window, data: dict[str, Any]) -> None:
            set_background(boss, window, data["focused"])
      '';

      settings = {
        active_tab_font_style = "bold";
        allow_remote_control = "yes";
        bold_font = "auto";
        bold_italic_font = "auto";
        confirm_os_window_close = "1";
        cursor_beam_thickness = "2";
        cursor_blink_interval = "0";
        cursor_shape = "beam";
        cursor_trail = "1";
        cursor_trail_decay = "0.1 0.3";
        cursor_trail_start_threshold = "0";
        enabled_layouts = "tall:bias=50;full_size=1;mirrored=false,stack,splits";
        focus_follows_mouse = "yes";
        font_family = ''family="${fonts.mono}"'';
        font_size = "12";
        hide_window_decorations = "yes";
        inactive_tab_font_style = "normal";
        # inactive_text_alpha = "0.90";
        italic_font = "auto";
        linux_display_server = "wayland";
        listen_on = "unix:\${XDG_RUNTIME_DIR}/kitty-{kitty_pid}";
        mouse_hide_wait = "1";
        notify_on_cmd_finish = "unfocused 5";
        scrollback_fill_enlarged_window = "yes";
        scrollback_lines = "10000";
        scrollback_pager = "${getExe pkgs.ov} --wrap=false -";
        scrollback_pager_history_size = "64";
        shell = getExe pkgs.fish;
        shell_integration = "enabled";
        tab_bar_edge = "top";
        tab_bar_style = "slant";
        update_check_interval = "0";
        watcher = "${inactiveBgWatcher}";
        wayland_enable_ime = "no";
      };

      mappings = {
        "alt+1" = "goto_tab 1";
        "alt+2" = "goto_tab 2";
        "alt+3" = "goto_tab 3";
        "alt+4" = "goto_tab 4";
        "alt+5" = "goto_tab 5";
        "alt+6" = "goto_tab 6";
        "alt+7" = "goto_tab 7";
        "alt+8" = "goto_tab 8";
        "alt+9" = "goto_tab -1";
        "alt+[" = "previous_window";
        "alt+]" = "next_window";
        "alt+enter" = "launch --location=vsplit --cwd=current";
        "alt+shift+q" = "close_window_with_confirmation ignore-shell";
        "alt+space" = "toggle_layout stack";
        "alt+t" = "command_palette";
        "alt+tab" = "next_tab";
        "alt+w" = "next_window";
        "ctrl++" = "change_font_size all +1.0";
        "ctrl+-" = "change_font_size all -1.0";
        "ctrl+/" = "search_scrollback";
        "ctrl+0" = "change_font_size all 0";
        "ctrl+alt+[" = "move_tab_backward";
        "ctrl+alt+]" = "move_tab_forward";
        "ctrl+alt+b" = "detach_window new-tab";
        "ctrl+alt+e" = "kitten hints --type linenum";
        "ctrl+alt+f" = "kitten hints --type path --program -";
        "ctrl+alt+g" = "show_last_visited_command_output";
        "ctrl+alt+j" = "layout_action decrease_num_full_size_windows";
        "ctrl+alt+k" = "layout_action increase_num_full_size_windows";
        "ctrl+alt+m" = "layout_action mirror toggle";
        "ctrl+alt+o" = "detach_window ask";
        "ctrl+alt+shift+f" = "kitten choose-files";
        "ctrl+alt+shift+o" = "detach_tab ask";
        "ctrl+alt+w" = "layout_action bias 50 62 70";
        "ctrl+alt+y" = "copy_last_command_output";
        "ctrl+enter" = "launch --type=tab --cwd=current";
        "ctrl+equal" = "change_font_size all +1.0";
        "ctrl+s" = "show_scrollback";
        "ctrl+shift+-" = "show_last_command_output";
        "ctrl+shift+c" = "copy_to_clipboard";
        "ctrl+shift+g" = "show_last_command_output";
        "ctrl+shift+p" = "command_palette";
        "ctrl+shift+v" = "paste_from_clipboard";
        "ctrl+shift+x" = "scroll_to_prompt 1";
        "ctrl+shift+z" = "scroll_to_prompt -1";
      };

      editorPassthroughKeys = [
        "alt+w"
        "alt+["
        "alt+]"
        "alt+t"
        "ctrl++"
        "ctrl+-"
        "ctrl+0"
        "ctrl+alt+["
        "ctrl+alt+]"
        "ctrl+alt+b"
        "ctrl+alt+j"
        "ctrl+alt+k"
        "ctrl+alt+m"
        "ctrl+alt+o"
        "ctrl+alt+shift+o"
        "ctrl+alt+w"
        "ctrl+enter"
        "ctrl+equal"
        "ctrl+shift+c"
        "ctrl+shift+v"
        "alt+1"
        "alt+2"
        "alt+3"
        "alt+4"
        "alt+5"
        "alt+6"
        "alt+7"
        "alt+8"
        "alt+9"
      ];

      maps = mapAttrsToList (key: action: "${key} ${action}") mappings;

      # no_op under a focus condition forwards the key to the program instead
      # of running the kitty action; nvim sets the in_editor var itself.
      editorLockedKeys = subtractLists editorPassthroughKeys <| attrNames mappings;
      editorLockMaps = map (key: "--when-focus-on var:in_editor ${key} no_op") editorLockedKeys;

      colors = {
        background = activeBackground;
        foreground = "#${palette.fgMain}";
        selection_background = "#${palette.bgSelection}";
        selection_foreground = "#${palette.fgMain}";
        url_color = "#${palette.fgAlt}";
        cursor = "#${palette.fgMain}";
        cursor_text_color = "#${palette.bgMain}";

        active_tab_background = "#545454";
        active_tab_foreground = "#${palette.fgMain}";
        inactive_tab_background = "#262626";
        inactive_tab_foreground = "#969696";

        active_border_color = "#${palette.blueWarmer}";
        inactive_border_color = "#${palette.border}";

        color0 = "#${palette.bgMain}";
        color1 = "#${palette.red}";
        color2 = "#${palette.green}";
        color3 = "#${palette.yellow}";
        color4 = "#${palette.blue}";
        color5 = "#${palette.magenta}";
        color6 = "#${palette.cyan}";
        color7 = "#${palette.termWhite}";

        color8 = "#${palette.termBrightBlack}";
        color9 = "#${palette.redWarmer}";
        color10 = "#${palette.greenCooler}";
        color11 = "#${palette.yellowWarmer}";
        color12 = "#${palette.blueWarmer}";
        color13 = "#${palette.magentaWarmer}";
        color14 = "#${palette.cyanCooler}";
        color15 = "#${palette.fgMain}";

        color16 = "#${palette.yellowWarmer}";
        color17 = "#${palette.redFaint}";
      };

    in
    {
      hjem.users.${user.name}.rum.programs.kitty = {
        enable = true;
        settings = settings // colors // {
          clear_all_shortcuts = "yes";
          map = maps ++ editorLockMaps;
        };
      };
    };
}
