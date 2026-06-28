_: {
  flake.nixosModules.gtk =
    { lib, pkgs, ... }:
    let
      inherit (lib.gvariant) mkInt32;
      inherit (lib.lists) singleton;

      colloid = pkgs.colloid-gtk-theme.override {
        themeVariants = singleton "purple";
        tweaks = singleton "nord";
      };
    in
    {
      environment.systemPackages = [
        pkgs.bibata-cursors
        colloid
        pkgs.tela-circle-icon-theme
        pkgs.tela-icon-theme
      ];

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
                font-name = "Inter 11";
                document-font-name = "Inter 11";
                monospace-font-name = "JetBrainsMono Nerd Font 12";
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
