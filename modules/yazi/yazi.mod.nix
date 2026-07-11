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

      copyFileContents = pkgs.callPackage (
        { fetchFromGitHub, yaziPlugins }:
        yaziPlugins.mkYaziPlugin {
          pname = "copy-file-contents.yazi";
          version = "71545f4";
          src = "${
            fetchFromGitHub {
              owner = "AnirudhG07";
              repo = "plugins-yazi";
              rev = "71545f4";
              hash = "sha256-JsQJg/SfXLQ/JIpl2YsfzdGpS1ZeWIACJwWTpHaVH3w=";
            }
          }/copy-file-contents.yazi";
        }
      ) { };
    in
    {
      hjem.users.${user.name} = {
        rum.programs.yazi = {
          enable = true;
          settings = {
            mgr = {
              ratio = [
                1
                2
                2
              ];
              linemode = "none";
              show_hidden = true;
              show_symlink = true;
              sort_by = "mtime";
              sort_dir_first = true;
              sort_reverse = true;
              sort_sensitive = true;
            };

            preview = {
              tab_size = 2;
              max_width = 4000;
              max_height = 4000;
              cache_dir = "";
              ueberzug_scale = 1;
              ueberzug_offset = [
                0
                0
                0
                0
              ];
            };

            plugin.prepend_fetchers = [
              {
                url = "*";
                run = "git";
                group = "git";
              }
              {
                url = "*/";
                run = "git";
                group = "git";
              }
            ];
          };

          keymap = {
            mgr.prepend_keymap = [
              {
                on = "!";
                for = "unix";
                run = ''shell "$SHELL" --block'';
                desc = "Open $SHELL here";
              }
              {
                on = [
                  "c"
                  "m"
                ];
                run = "plugin chmod";
                desc = "Chmod on selected files";
              }
              {
                on = "l";
                run = "plugin smart-enter";
                desc = "Enter the child directory, or open the file";
              }
              {
                on = "<Enter>";
                run = "plugin smart-enter";
                desc = "Enter the child directory, or open the file";
              }
              {
                on = "F";
                run = "plugin smart-filter";
                desc = "Smart filter";
              }
              {
                on = [
                  "g"
                  "r"
                ];
                run = ''shell -- ya emit cd "$(git rev-parse --show-toplevel)"'';
              }
              {
                on = [
                  "c"
                  "y"
                ];
                run = singleton "plugin copy-file-contents";
                desc = "Copy contents of file";
              }
              {
                on = singleton "`";
                desc = "Command palette (fzf)";
                run = "plugin command-palette";
              }
            ];

            input.prepend_keymap = singleton {
              on = "<Esc>";
              run = "close";
              desc = "Cancel input";
            };
          };

          theme.flavor.dark = "modus-vivendi";
        };

        xdg.config.files = {
          "yazi/init.lua".source = ./init.lua;
          "yazi/plugins/chmod.yazi".source = pkgs.yaziPlugins.chmod;
          "yazi/plugins/copy-file-contents.yazi".source = copyFileContents;
          "yazi/plugins/git.yazi".source = pkgs.yaziPlugins.git;
          "yazi/plugins/smart-enter.yazi".source = pkgs.yaziPlugins.smart-enter;
          "yazi/plugins/smart-filter.yazi".source = pkgs.yaziPlugins.smart-filter;
        };
      };
    };
}
