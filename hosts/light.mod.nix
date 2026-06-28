{
  config,
  lib,
  ...
}:
let
  inherit (lib.lists) singleton;
in
{
  flake.nixosConfigurations.light = config.flake.lib.mkHost {
    hostName = "light";
    kernelPackages = pkgs: pkgs.cachyosKernels.linuxPackages-cachyos-latest-zen4;
    excludeModules = singleton "auto-cpufreq";
    extraModules = singleton { nix.settings.system-features = singleton "gccarch-znver4"; };
  };
}
