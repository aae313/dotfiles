_: {
  flake.nixosModules.xdg =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;

      inherit (config.local) user;

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
        "text/*" = singleton "nv.desktop";
        "application/json" = browser;
        "inode/directory" = singleton "yazi.desktop";
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
        config.common.default = "*";
      };

      hjem.users.${user.name} = {
        rum.programs.mpv.enable = true;

        xdg.mime-apps.default-applications = associations;

        xdg.config.files = {
          "user-dirs.conf".text = /* conf */ ''
            enabled=False
          '';

          "user-dirs.dirs".text = /* conf */ ''
            XDG_DESKTOP_DIR="${user.home}/misc"
            XDG_DOCUMENTS_DIR="${user.home}/misc"
            XDG_DOWNLOAD_DIR="${user.home}/Downloads"
            XDG_MUSIC_DIR="${user.home}/misc"
            XDG_PICTURES_DIR="${user.home}/misc"
            XDG_PUBLICSHARE_DIR="${user.home}/misc"
            XDG_TEMPLATES_DIR="${user.home}/misc"
            XDG_VIDEOS_DIR="${user.home}/misc"
            XDG_BOOKS_DIR="${user.home}/misc/books"
            XDG_DEV_DIR="${user.home}/dev"
          '';

          "xdg-terminals.list".text = /* conf */ ''
            kitty.desktop
          '';
        };
      };
    };
}
