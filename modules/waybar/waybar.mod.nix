{ config, ... }:
let
  inherit (config.flake.lib) linkConfigDir;
in
{
  flake.nixosModules.waybar =
    {
      config,
      pkgs,
      ...
    }:
    let
      inherit (config.local) user;
    in
    {
      programs.waybar.enable = true;

      systemd.user.services.waybar.path = [
        config.programs.niri.package
        pkgs.jq
      ];

      hjem.users.${user.name}.xdg.config.files = linkConfigDir ./config "waybar";
    };
}
