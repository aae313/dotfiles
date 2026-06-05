{ pkgs, lib, ... }:
let
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.generators) toINI;
  inherit (lib.meta) getExe;
  inherit (lib.strings) concatStringsSep;

  browser = [ "firefox-nightly.desktop" ];
  editor = [ "helix-terminal.desktop" ];

  helixDesktopItem = pkgs.makeDesktopItem {
    name = "helix-terminal";
    desktopName = "Helix";
    exec = "${getExe pkgs.foot} --app-id helix ${getExe pkgs.helix} %F";
    mimeTypes = [ "text/plain" ];
    categories = [
      "Utility"
      "TextEditor"
    ];
  };

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
    "text/plain" = editor;
    "inode/directory" = [ "yazi" ];
  };
in
{
  environment.systemPackages = [
    pkgs.shared-mime-info
    pkgs.xdg-desktop-portal
    pkgs.xdg-user-dirs
    pkgs.xdg-utils
    helixDesktopItem
  ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  environment.etc."xdg/mimeapps.list".text = toINI { } {
    "Default Applications" = mapAttrs (_: v: concatStringsSep ";" v + ";") associations;
  };
}
