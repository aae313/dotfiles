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
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly.packages.${system}.default;
    vimAlias = true;
    viAlias = true;
  };

  environment.systemPackages = singleton pkgs.neovide;
}
