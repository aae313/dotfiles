{ pkgs, ... }:
{
  programs.foot = {
    enable = true;
    xdg.serverAutostart = true;
  };

  environment.systemPackages = [
    pkgs.ghostty
  ];
}
