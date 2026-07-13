{ config, ... }:
let
  inherit (config.flake.lib) linkConfigDir;
in
{
  flake.nixosModules.fish =
    { config, lib, ... }:
    let
      inherit (lib.strings) fileContents;

      inherit (config.local) user;
      inherit (config.local.theme) palette;
    in
    {
      programs.fish.enable = true;

      hjem.users.${user.name} = {
        rum.programs = {
          direnv = {
            enable = true;
            integrations = {
              fish.enable = true;
              nix-direnv.enable = true;
            };
          };

          fish = {
            enable = true;
            package = null;
            config =
              /* fish */ ''
                set -gx FZF_DEFAULT_OPTS "--multi --highlight-line --cycle --layout=reverse --height=80% \
                --info=inline-right \
                --ansi \
                --color=bg+:#${palette.bgCompletion},bg:#${palette.bgMain},spinner:#${palette.cyan},hl:#${palette.yellow} \
                --color=fg:#${palette.fgMain},header:#${palette.fgAlt},info:#${palette.fgDim},pointer:#${palette.blue} \
                --color=marker:#${palette.cyan},fg+:#${palette.fgMain},prompt:#${palette.blue},hl+:#${palette.yellow} \
                --color=selected-bg:#${palette.bgInactive} \
                --color=border:#${palette.border},label:#${palette.fgMain}"
              ''
              + fileContents ./config/config.fish;
          };

          fzf = {
            enable = true;
            integrations.fish.enable = true;
          };

          nix-your-shell = {
            enable = true;
            integrations.fish.enable = true;
          };

          zoxide = {
            enable = true;
            flags = [
              "--cmd"
              "cd"
            ];
            integrations.fish.enable = true;
          };
        };

        xdg.config.files = linkConfigDir ./config/functions "fish/functions" // {
          "fish/themes/catppuccin-mocha.theme".source = ./config/themes/catppuccin-mocha.theme;
          "fish/themes/modus.theme".text = /* fish */ ''
            # name: 'modus-vivendi'
            # preferred_background: ${palette.bgMain}

            fish_color_normal ${palette.fgMain}
            fish_color_command ${palette.cyan}
            fish_color_keyword ${palette.magenta}
            fish_color_quote ${palette.yellow}
            fish_color_redirection ${palette.fgMain}
            fish_color_end ${palette.yellowWarmer}
            fish_color_option ${palette.magenta}
            fish_color_error ${palette.red}
            fish_color_param ${palette.magentaCooler}
            fish_color_comment ${palette.fgDim}
            fish_color_selection --background=${palette.bgSelection}
            fish_color_search_match --background=${palette.bgSelection}
            fish_color_operator ${palette.green}
            fish_color_escape ${palette.magenta}
            fish_color_autosuggestion ${palette.fgDim}

            fish_pager_color_progress ${palette.fgDim}
            fish_pager_color_prefix ${palette.cyan}
            fish_pager_color_completion ${palette.fgMain}
            fish_pager_color_description ${palette.fgDim}
            fish_pager_color_selected_background --background=${palette.bgSelection}
          '';
        };
      };
    };
}
