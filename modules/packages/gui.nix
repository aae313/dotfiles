{ inputs, pkgs, ... }:

{
  environment.systemPackages = [
    inputs.claude-desktop.packages.x86_64-linux.default
    pkgs.anki
    pkgs.imv
    # pkgs.mpv
    pkgs.obsidian
    pkgs.pwvucontrol
    pkgs.ticktick
    pkgs.vesktop
    pkgs.zathura
  ];
}
