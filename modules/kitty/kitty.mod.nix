_: {
  flake.nixosModules.kitty =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.attrsets) mapAttrsToList;
      inherit (lib.lists) singleton;
      inherit (lib.strings) concatLines;

      inherit (config.local) user;
      inherit (config.local.theme) fonts;

      settings = {
        window_padding_width = "6 8 6 8";
        active_tab_font_style = "bold";
        allow_remote_control = "socket-only";
        bold_font = "auto";
        bold_italic_font = "auto";
        confirm_os_window_close = "1";
        cursor_beam_thickness = "2";
        cursor_blink_interval = "0";
        cursor_shape = "beam";
        cursor_trail = "1";
        cursor_trail_decay = "0.1 0.3";
        cursor_trail_start_threshold = "2";
        enabled_layouts = "tall:bias=50;full_size=1;mirrored=false,stack,splits";
        focus_follows_mouse = "yes";
        font_family = ''family="${fonts.mono}"'';
        font_size = "11";
        hide_window_decorations = "yes";
        inactive_tab_font_style = "normal";
        inactive_text_alpha = "0.7";
        italic_font = "auto";
        linux_display_server = "wayland";
        listen_on = "unix:\${XDG_RUNTIME_DIR}/kitty-{kitty_pid}";
        mouse_hide_wait = "1";
        notify_on_cmd_finish = "unfocused 5";
        scrollback_fill_enlarged_window = "yes";
        scrollback_lines = "10000";
        scrollback_pager_history_size = "64";
        shell = "${pkgs.fish}/bin/fish";
        shell_integration = "enabled";
        wayland_enable_ime = "no";
        tab_bar_edge = "top";
        tab_bar_style = "slant";
        update_check_interval = "0";
      };

      maps =
        mapAttrsToList (name: value: "map alt+${name} goto_tab ${value}") {
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
          "6" = "6";
          "7" = "7";
          "8" = "8";
          "9" = "-1";
        }
        ++ [
          "map alt+[ previous_window"
          "map alt+] next_window"
          "map alt+enter launch --location=vsplit --cwd=current"
          "map alt+shift+q close_window_with_confirmation ignore-shell"
          "map alt+space toggle_layout stack"
          "map alt+t command_palette"
          "map alt+tab next_tab"
          "map alt+w next_window"
          "map ctrl++ change_font_size all +1.0"
          "map ctrl+- change_font_size all -1.0"
          "map ctrl+0 change_font_size all 0"
          "map ctrl+alt+[ move_tab_backward"
          "map ctrl+alt+] move_tab_forward"
          "map ctrl+alt+b detach_window new-tab"
          "map ctrl+alt+w layout_action bias 50 62 70"
          "map ctrl+alt+j layout_action decrease_num_full_size_windows"
          "map ctrl+alt+k layout_action increase_num_full_size_windows"
          "map ctrl+alt+m layout_action mirror toggle"
          "map ctrl+alt+o detach_window ask"
          "map ctrl+alt+shift+o detach_tab ask"
          "map ctrl+enter launch --type=tab --cwd=current"
          "map ctrl+equal change_font_size all +1.0"
          "map ctrl+/ search_scrollback"
          "map ctrl+shift+- show_last_command_output"
          "map ctrl+shift+c copy_to_clipboard"
          "map ctrl+s show_scrollback"
          "map ctrl+shift+p command_palette"
          "map ctrl+shift+v paste_from_clipboard"
          "map ctrl+alt+y copy_last_command_output"
          "map ctrl+alt+e kitten hints --type linenum"
          "map ctrl+alt+f kitten hints --type path --program -"
          "map ctrl+shift+z scroll_to_prompt -1"
          "map ctrl+shift+x scroll_to_prompt 1"
          "map ctrl+shift+g show_last_command_output"
          "map ctrl+alt+g show_last_visited_command_output"
          "map ctrl+alt+shift+f kitten choose-files"
        ];

      colors = {
        background = "#000000";
        foreground = "#ffffff";
        selection_background = "#7030af";
        selection_foreground = "#ffffff";
        url_color = "#c6daff";
        cursor = "#ffffff";
        cursor_text_color = "#000000";

        active_tab_background = "#545454";
        active_tab_foreground = "#ffffff";
        inactive_tab_background = "#2f2f2f";
        inactive_tab_foreground = "#969696";

        active_border_color = "#79a8ff";
        inactive_border_color = "#646464";

        color0 = "#000000";
        color1 = "#ff5f59";
        color2 = "#44bc44";
        color3 = "#d0bc00";
        color4 = "#2fafff";
        color5 = "#feacd0";
        color6 = "#00d3d0";
        color7 = "#a6a6a6";

        color8 = "#595959";
        color9 = "#ff6b55";
        color10 = "#00c06f";
        color11 = "#fec43f";
        color12 = "#79a8ff";
        color13 = "#f78fe7";
        color14 = "#6ae4b9";
        color15 = "#ffffff";

        color16 = "#fec43f";
        color17 = "#ff9580";
      };

      toKittyLine = name: value: "${name} ${value}";
    in
    {
      hjem.users.${user.name} = {
        packages = singleton pkgs.kitty;

        xdg.config.files."kitty/kitty.conf".text = /* kitty */ ''
          ${concatLines (mapAttrsToList toKittyLine settings)}

          clear_all_shortcuts yes
          ${concatLines maps}

          ${concatLines (mapAttrsToList toKittyLine colors)}
        '';
      };
    };
}
