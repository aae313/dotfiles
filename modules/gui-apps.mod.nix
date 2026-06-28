_: {
  flake.nixosModules.gui-apps =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.anki
        pkgs.imv
        # pkgs.obsidian
        pkgs.pwvucontrol
        pkgs.ticktick
        # pkgs.vesktop
        pkgs.zathura
      ];
    };
}
