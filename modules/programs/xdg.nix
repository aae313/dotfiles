{ pkgs, lib, ... }:
let
  browser = [ "firefox-nightly.desktop" ];

  associations = {
    "text/html" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/xhtml+xml" = browser;
    "application/x-extension-xhtml" = browser;
    "application/x-extension-xht" = browser;
    "audio/*" = [ "mpv.desktop" ];
    "video/*" = [ "mpv.desktop" ];
    "image/*" = [ "imv.desktop" ];
    "application/json" = browser;
    "text/plain" = [ "nvim" ];
    "inode/directory" = [ "yazi" ];
  };
in
{
  environment.systemPackages = [
    pkgs.shared-mime-info
    pkgs.xdg-desktop-portal
    pkgs.xdg-user-dirs
    pkgs.xdg-utils
  ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config.common.default = [ "gnome" "gtk" ];
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
  };

  environment.etc."xdg/mimeapps.list".text = lib.generators.toINI { } {
    "Default Applications" = lib.mapAttrs (_: v: lib.concatStringsSep ";" v + ";") associations;
  };
}
