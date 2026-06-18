{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkForce;
  inherit (pkgs.stdenv.hostPlatform) system;
  inherit (inputs.nix-cachyos-kernel.legacyPackages.${system}) linuxPackages-cachyos-latest-lto;
in
{
  boot.kernelPackages = mkForce linuxPackages-cachyos-latest-lto;
}
