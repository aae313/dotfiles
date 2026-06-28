_: {
  flake.nixosModules.xdg =
    { lib, pkgs, ... }:
    let
      inherit (lib.attrsets) mapAttrs;
      inherit (lib.generators) toINI;
      inherit (lib.lists) singleton;
      inherit (lib.strings) concatStringsSep;

      browser = singleton "firefox-nightly.desktop";

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
        "audio/*" = singleton "mpv.desktop";
        "video/*" = singleton "mpv.desktop";
        "image/*" = singleton "imv.desktop";
        "application/json" = browser;
        "inode/directory" = singleton "yazi.desktop";
      };
    in
    {
      environment.systemPackages = [
        pkgs.mpv
        pkgs.shared-mime-info
        pkgs.xdg-desktop-portal
        pkgs.xdg-user-dirs
        pkgs.xdg-utils
      ];

      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        config.common.default = "*";
      };

      environment.etc."xdg/mimeapps.list".text = toINI { } {
        "Default Applications" = mapAttrs (_: v: concatStringsSep ";" v + ";") associations;
      };
    };
}
