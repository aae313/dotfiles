{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkForce;
in
{
  boot.kernelPackages = mkForce pkgs.linuxPackages_cachyos-lto-znver4;

  nix.settings.system-features = singleton "gccarch-znver4";
}
