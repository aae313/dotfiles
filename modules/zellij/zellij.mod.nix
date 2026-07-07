{ config, ... }:
let
  inherit (config.flake.lib) linkConfigDir;
in
{
  flake.nixosModules.zellij =
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
        packages = singleton pkgs.zellij;

        xdg.config.files = linkConfigDir ./config "zellij";
      };
    };
}
