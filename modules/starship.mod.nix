{ inputs, ... }:
{
  flake.nixosModules.starship =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe;

      inherit (config.local) user;
      inherit (config.local.theme) palette;
      inherit (pkgs.stdenv.hostPlatform) system;

      jjStarship = getExe inputs.jj-starship.packages.${system}.default;
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
            detect_files = singleton "Makefile";
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
            shell = singleton jjStarship;
            when = "${jjStarship} detect";
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
            context = "#${palette.blue}";
            duration = "#${palette.magenta}";
            error = "#${palette.red}";
            muted = "#${palette.fgDim}";
            path = "#${palette.cyanCooler}";
            remote = "#${palette.green}";
            warning = "#${palette.yellowWarmer}";

            fg-main = "#${palette.fgMain}";
            fg-alt = "#${palette.fgAlt}";
            fg-dim = "#${palette.fgDim}";

            bg-main = "#${palette.bgMain}";
            bg-dim = "#${palette.bgDim}";
            bg-inactive = "#${palette.bgInactive}";
            bg-active = "#${palette.bgActive}";

            border = "#${palette.border}";

            red = "#${palette.red}";
            red-cooler = "#${palette.redCooler}";
            red-faint = "#${palette.redFaint}";

            green = "#${palette.green}";

            yellow = "#${palette.yellow}";
            yellow-cooler = "#${palette.yellowCooler}";

            blue = "#${palette.blue}";
            blue-cooler = "#${palette.blueCooler}";

            cyan = "#${palette.cyan}";
            cyan-cooler = "#${palette.cyanCooler}";

            magenta = "#${palette.magenta}";
            magenta-cooler = "#${palette.magentaCooler}";

            indigo = "#${palette.indigo}";
          };
        };
      };
    };
}
