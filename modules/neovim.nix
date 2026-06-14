{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) singleton;
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  environment.systemPackages = singleton inputs.nixpkgs.legacyPackages.${system}.neovide;

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly.packages.${system}.default;
    vimAlias = false;
    viAlias = false;
  };
}
