{
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (lib.attrsets) attrValues removeAttrs;
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkForce;
in
{
  flake.nixosConfigurations.light = inputs.nixpkgs.lib.nixosSystem {
    modules = attrValues (removeAttrs config.flake.nixosModules [ "auto-cpufreq" ]) ++ [
      { networking.hostName = "light"; }
      (
        { pkgs, ... }:
        {
          nixpkgs.overlays = singleton inputs.nix-cachyos-kernel.overlays.pinned;

          boot.kernelPackages = mkForce pkgs.cachyosKernels.linuxPackages-cachyos-latest-zen4;

          nix.settings.system-features = singleton "gccarch-znver4";
        }
      )
    ];
  };
}
