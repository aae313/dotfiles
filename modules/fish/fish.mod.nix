{ config, ... }:
let
  inherit (config.flake.lib) linkConfigDir;
in
{
  flake.nixosModules.fish =
    { config, ... }:
    let
      inherit (config.local) user;
    in
    {
      programs.fish.enable = true;

      hjem.users.${user.name}.xdg.config.files = linkConfigDir ./config "fish";
    };
}
