_: {
  flake.nixosModules.wayland-tools =
    { config, pkgs, ... }:
    let
      inherit (config.local) user;
    in
    {
      hjem.users.${user.name}.packages = [
        pkgs.dex
        pkgs.libnotify
        pkgs.wl-clipboard
        pkgs.grim
        pkgs.slurp
        pkgs.satty
      ];
    };
}
