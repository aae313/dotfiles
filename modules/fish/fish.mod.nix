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
            config = fileContents ./config/config.fish;
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

        xdg.config.files =
          linkConfigDir ./config/functions "fish/functions"
          // linkConfigDir ./config/themes "fish/themes";
      };
    };
}
