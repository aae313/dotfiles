{
  lib,
  pkgs,
  inputs,
  ...
}:

{
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly.packages.${pkgs.stdenv.hostPlatform.system}.default;
    withRuby = false;
    vimAlias = true;
    viAlias = true;
  };

  environment.systemPackages = lib.lists.singleton pkgs.neovide;
}
