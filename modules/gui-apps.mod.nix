_: {
  flake.nixosModules.gui-apps =
    { config, pkgs, ... }:
    let
      inherit (config.local) user;
    in
    {
      hjem.users.${user.name}.packages = [
        pkgs.anki
        pkgs.imv
        # pkgs.obsidian
        pkgs.pwvucontrol
        pkgs.ticktick
        # pkgs.vesktop
      ];
    };
}
