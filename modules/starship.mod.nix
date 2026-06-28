_: {
  flake.nixosModules.starship =
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
      hjem.users.${user.name} = {
        packages = singleton pkgs.starship;

        xdg.config.files."starship.toml".generator = pkgs.writers.writeTOML "starship.toml";
        xdg.config.files."starship.toml".value = {
          add_newline = false;
          command_timeout = 100;
          format = "$status$hostname$directory\${custom.jj}$nix_shell$package$c$python$lua$rust$cmd_duration$jobs$container\n$character";
          palette = "modus_vivendi";
          scan_timeout = 2;

          c = {
            detect_files = [ "Makefile" ];
            format = "[$symbol$version]($style) ";
            style = "bold context";
          };

          character = {
            success_symbol = "[->](bold magenta)";
            error_symbol = "[->](bold red)";
            vimcmd_replace_one_symbol = "[](fg-alt) [❮](magenta)";
            vimcmd_replace_symbol = "[](fg-alt) [❮](bold yellow)";
            vimcmd_symbol = "[](fg-alt) [❮](bold yellow)";
            vimcmd_visual_symbol = "[](fg-alt) [❮](bold yellow-cooler)";
          };

          cmd_duration = {
            format = "[$duration](duration) ";
            min_time = 2000;
            show_milliseconds = false;
          };

          container = {
            format = "[$symbol$name]($style) ";
            style = "bold context";
          };

          custom.jj = {
            format = "$output ";
            shell = [ "jj-starship" ];
            when = "jj-starship detect";
          };

          directory = {
            format = "[$path]($style)[$read_only]($read_only_style) ";
            read_only = " ";
            read_only_style = "warning";
            style = "bold path";
            truncate_to_repo = false;
            truncation_length = 100;
          };

          git_branch.disabled = true;
          git_commit.disabled = true;
          git_state.disabled = true;
          git_status.disabled = true;

          hostname = {
            disabled = false;
            format = "[@$hostname](bold remote) ";
            ssh_only = true;
          };

          jobs = {
            format = "[$symbol$number]($style) ";
            style = "bold context";
          };

          lua = {
            format = "[$symbol$version]($style) ";
            style = "bold context";
          };

          nix_shell = {
            format = "[via](muted) [$symbol$name]($style) ";
            heuristic = true;
            style = "bold context";
            symbol = " ";
          };

          package = {
            format = "[$symbol$version]($style) ";
            style = "bold context";
            symbol = " ";
          };

          python = {
            format = "[$symbol$pyenv_prefix($version )(($virtualenv) )]($style)";
            style = "bold context";
          };

          rust = {
            format = "[$symbol$version]($style) ";
            style = "bold context";
          };

          status = {
            disabled = false;
            format = "[exit $status](error) ";
          };

          palettes.modus_vivendi = {
            context = "#2fafff";
            duration = "#feacd0";
            error = "#ff5f59";
            muted = "#989898";
            path = "#6ae4b9";
            remote = "#44bc44";
            warning = "#fec43f";

            fg-main = "#ffffff";
            fg-alt = "#c6daff";
            fg-dim = "#989898";

            bg-main = "#000000";
            bg-dim = "#1e1e1e";
            bg-inactive = "#303030";
            bg-active = "#535353";

            border = "#646464";

            red = "#ff5f59";
            red-cooler = "#ff7f86";
            red-faint = "#ff9580";

            green = "#44bc44";

            yellow = "#d0bc00";
            yellow-cooler = "#dfaf7a";

            blue = "#2fafff";
            blue-cooler = "#00bcff";

            cyan = "#00d3d0";
            cyan-cooler = "#6ae4b9";

            magenta = "#feacd0";
            magenta-cooler = "#b6a0ff";

            indigo = "#9099d9";
          };
        };
      };
    };
}
