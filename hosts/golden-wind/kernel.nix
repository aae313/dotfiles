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
  imports = singleton ../../modules/kernel/cachyos.nix;

  boot.kernelPackages = mkForce pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;
}
