{
  config,
  ...
}:
{
  flake.nixosConfigurations.golden-wind = config.flake.lib.mkHost {
    hostName = "golden-wind";
    kernelPackages = pkgs: pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;
  };
}
