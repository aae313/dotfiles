{
  pkgs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "size=12G"
        "mode=755"
      ];
    };
    "/persist" = {
      neededForBoot = true;
      device = "/dev/disk/by-label/NIXOS";
      fsType = "btrfs";
      options = [
        "noatime"
        "subvol=persist"
        "compress=zstd:1"
      ];
    };
    "/home" = {
      device = "/dev/disk/by-label/NIXOS";
      fsType = "btrfs";
      options = [
        "noatime"
        "subvol=home"
        "compress=zstd:1"
      ];
    };
    "/nix" = {
      neededForBoot = true;
      device = "/dev/disk/by-label/NIXOS";
      fsType = "btrfs";
      options = [
        "noatime"
        "subvol=nix"
        "compress=zstd:1"
      ];
    };
    "/var/log" = {
      device = "/dev/disk/by-label/NIXOS";
      fsType = "btrfs";
      neededForBoot = true;
      options = [
        "noatime"
        "subvol=log"
        "compress=zstd:1"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [ "noatime" ];
    };
  };
  swapDevices = [ ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  boot.kernelModules = [ "i2c-dev" ];

  environment.systemPackages = with pkgs; [
    ddcutil
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
