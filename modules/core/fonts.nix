{ pkgs, lib, ... }:
let
  inherit (lib.lists) singleton;
in
{
  fonts = {
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
      serif = singleton "Inter";
      sansSerif = singleton "Inter";
      monospace = singleton "JetBrains Mono Nerd Font";
      emoji = singleton "Noto Color Emoji";
    };
  };
}
