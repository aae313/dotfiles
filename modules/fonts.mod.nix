_: {
  flake.nixosModules.fonts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;
      inherit (lib.options) mkOption;
      inherit (lib.types) str;

      inherit (config.local.theme) fonts;
    in
    {
      options.local.theme.fonts = {
        mono = mkOption {
          type = str;
          default = "JetBrainsMono Nerd Font";
        };

        sans = mkOption {
          type = str;
          default = "Inter";
        };

        symbols = mkOption {
          type = str;
          default = "Symbols Nerd Font";
        };

        emoji = mkOption {
          type = str;
          default = "Noto Color Emoji";
        };
      };

      config.fonts = {
        packages = [
          pkgs.material-symbols
          pkgs.noto-fonts

          pkgs.noto-fonts-color-emoji
          pkgs.roboto
          (pkgs.google-fonts.override { fonts = singleton "Inter"; })
          pkgs.jetbrains-mono
          pkgs.nerd-fonts.jetbrains-mono
          pkgs.nerd-fonts.symbols-only
        ];

        enableDefaultPackages = false;

        fontconfig.defaultFonts = {
          serif = singleton fonts.sans;
          sansSerif = singleton fonts.sans;
          monospace = singleton fonts.mono;
          emoji = singleton fonts.emoji;
        };
      };
    };
}
