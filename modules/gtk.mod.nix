_: {
  flake.nixosModules.gtk =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.gvariant) mkInt32;
      inherit (lib.lists) singleton;

      inherit (config.local) user;
      inherit (config.local.theme) fonts;

      colloid = pkgs.colloid-gtk-theme.override {
        themeVariants = singleton "purple";
        tweaks = singleton "nord";
      };
    in
    {
      hjem.users.${user.name}.rum.misc.gtk = {
        enable = true;
        gtk2Location = ".config/gtk-2.0/gtkrc";
        packages = [
          pkgs.bibata-cursors
          colloid
          pkgs.tela-icon-theme
        ];
        settings = {
          application-prefer-dark-theme = true;
          cursor-theme-name = "Bibata-Modern-Classic";
          cursor-theme-size = 24;
          font-name = "${fonts.sans} 11";
          icon-theme-name = "Tela-dracula-dark";
          theme-name = "Colloid-Purple-Dark-Nord";
        };
      };

      environment.variables = {
        XCURSOR_THEME = "Bibata-Modern-Classic";
        XCURSOR_SIZE = "24";
      };

      programs.dconf = {
        enable = true;
        profiles.user.databases = [
          {
            settings = {
              "org/gnome/desktop/interface" = {
                color-scheme = "prefer-dark";
                font-name = "${fonts.sans} 11";
                document-font-name = "${fonts.sans} 11";
                monospace-font-name = "${fonts.mono} 12";
                cursor-theme = "Bibata-Modern-Classic";
                cursor-size = mkInt32 24;
                gtk-theme = "Colloid-Purple-Dark-Nord";
                icon-theme = "Tela-dracula-dark";
              };
            };
          }
        ];
      };
    };
}
