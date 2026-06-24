{ lib, ... }:
let
  inherit (lib.lists) singleton;
in
{
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
      options = singleton "noatime";
    };
  };
  swapDevices = [ ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };
}
