{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkForce;
  inherit (pkgs.stdenv.hostPlatform) system;
  inherit (inputs.nix-cachyos-kernel.legacyPackages.${system}) linuxPackages-cachyos-latest-lto-zen4;
in
{
  boot.kernelPackages = mkForce linuxPackages-cachyos-latest-lto-zen4;

  nix.settings.system-features = singleton "gccarch-znver4";
}
