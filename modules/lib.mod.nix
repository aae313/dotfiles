{
  config,
  inputs,
  lib,
  ...
}:
let
  inherit (lib.attrsets) attrValues removeAttrs;
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkForce;
in
{
  flake.lib.mkHost =
    {
      hostName,
      kernelPackages,
      excludeModules ? [ ],
      extraModules ? [ ],
    }:
    inputs.nixpkgs.lib.nixosSystem {
      modules =
        attrValues (removeAttrs config.flake.nixosModules excludeModules)
        ++ [
          { networking.hostName = hostName; }
          (
            { pkgs, ... }:
            {
              nixpkgs.overlays = singleton inputs.nix-cachyos-kernel.overlays.pinned;

              boot.kernelPackages = mkForce (kernelPackages pkgs);
            }
          )
        ]
        ++ extraModules;
    };
}
