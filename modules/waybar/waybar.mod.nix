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

      systemd.user.services.waybar.path =
        config.environment.systemPackages ++ config.users.users.${user.name}.packages;

      hjem.users.${user.name} = {
        files.".local/bin/niri-taskbar".source = ./bin/niri-taskbar;

        xdg.config.files = linkConfigDir ./config "waybar";
      };
    };
}
