_: {
  flake.nixosModules.yazi =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;

      inherit (config.local) user;
    in
    {
      environment.systemPackages = singleton pkgs.yazi;

      hjem.users.${user.name}.xdg.config.files = {
        "yazi/init.lua".source = ../files/.config/yazi/init.lua;

        "yazi/yazi.toml".text = /* toml */ ''
          [mgr]
          ratio = [1, 2, 2]
          linemode = "none"
          show_hidden = true
          show_symlink = true
          sort_by = "mtime"
          sort_dir_first = true
          sort_reverse = true
          sort_sensitive = true

          [preview]
          tab_size = 2
          max_width = 4000
          max_height = 4000
          cache_dir = ""
          ueberzug_scale = 1
          ueberzug_offset = [0, 0, 0, 0]


          [[plugin.prepend_fetchers]]
          url = "*"
          run = "git"
          group = "git"

          [[plugin.prepend_fetchers]]
          url = "*/"
          run = "git"
          group = "git"
        '';

        "yazi/keymap.toml".text = /* toml */ ''
          [[mgr.prepend_keymap]]
          on = "!"
          for = "unix"
          run = 'shell "$SHELL" --block'
          desc = "Open $SHELL here"

          [[input.prepend_keymap]]
          on = "<Esc>"
          run = "close"
          desc = "Cancel input"

          [[mgr.prepend_keymap]]
          on = ["c", "m"]
          run = "plugin chmod"
          desc = "Chmod on selected files"

          [[mgr.prepend_keymap]]
          on = "l"
          run = "plugin smart-enter"
          desc = "Enter the child directory, or open the file"

          [[mgr.prepend_keymap]]
          on = "<Enter>"
          run = "plugin smart-enter"
          desc = "Enter the child directory, or open the file"


          [[mgr.prepend_keymap]]
          on = "F"
          run = "plugin smart-filter"
          desc = "Smart filter"


          [[mgr.prepend_keymap]]
          on = ["g", "r"]
          run = 'shell -- ya emit cd "$(git rev-parse --show-toplevel)"'

          [[mgr.prepend_keymap]]
          on = ["c", "y"]
          run = ["plugin copy-file-contents"]
          desc = "Copy contents of file"

          [[manager.prepend_keymap]]
          on = ["`"]
          desc = "Command palette (fzf)"
          run = "plugin command-palette"
        '';

        "yazi/theme.toml".text = /* toml */ ''
          [flavor]
          dark = "modus-vivendi"
        '';

        "yazi/package.toml".text = /* toml */ ''
          [[plugin.deps]]
          use = "yazi-rs/plugins:smart-filter"
          rev = "5d5c480"
          hash = "c887903a63a2ff520081b6d90a4b3392"

          [[plugin.deps]]
          use = "yazi-rs/plugins:smart-enter"
          rev = "5d5c480"
          hash = "187cc58ba7ac3befd49c342129e6f1b6"

          [[plugin.deps]]
          use = "yazi-rs/plugins:chmod"
          rev = "5d5c480"
          hash = "f0c8c378184d5f8abd1b095a443d336d"

          [[plugin.deps]]
          use = "AnirudhG07/plugins-yazi:copy-file-contents"
          rev = "71545f4"
          hash = "f8530ee84fee95dbcc26bb1d8d8019c7"

          [[plugin.deps]]
          use = "yazi-rs/plugins:git"
          rev = "598cdb6"
          hash = "88e56a64b7ce7c4314427452343fef17"

          [flavor]
          deps = []
        '';
      };
    };
}
