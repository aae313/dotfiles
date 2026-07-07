{ config, ... }:
let
  inherit (config.flake.lib) linkConfigDir;
in
{
  flake.nixosModules.waybar =
    {
      config,
      ...
    }:
    let
      inherit (config.local) user;
    in
    {
      programs.waybar.enable = true;
      hjem.users.${user.name}.xdg.config.files = linkConfigDir ./config "waybar";
    };
}
