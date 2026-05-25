{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkForce;
in
{
  nixpkgs.overlays = singleton inputs.cachyos-kernel.overlays.pinned;

  boot.kernelPackages = mkForce pkgs.cachyosKernels.linuxPackages-cachyos-latest-zen4;

  nix.settings.system-features = singleton "gccarch-znver4";
}
