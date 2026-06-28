{
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (lib.attrsets) attrValues;
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkForce;
in
{
  flake.nixosConfigurations.golden-wind = inputs.nixpkgs.lib.nixosSystem {
    modules = attrValues config.flake.nixosModules ++ [
      { networking.hostName = "golden-wind"; }
      (
        { pkgs, ... }:
        {
          nixpkgs.overlays = singleton inputs.nix-cachyos-kernel.overlays.pinned;

          boot.kernelPackages = mkForce pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;
        }
      )
    ];
  };
}
