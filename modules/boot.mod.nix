_: {
  flake.nixosModules.boot =
    { lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      boot = {
        initrd = {
          availableKernelModules = [
            "xhci_pci"
            "nvme"
            "usb_storage"
            "usbhid"
            "sd_mod"
          ];
          supportedFilesystems = [
            "btrfs"
            "ext4"
            "tmpfs"
            "vfat"
          ];
        };
        kernelModules = singleton "i2c-dev";
        loader = {
          timeout = 20;
          efi.canTouchEfiVariables = true;
          systemd-boot.enable = false;
          limine = {
            enable = true;
            maxGenerations = 8;
          };
        };
      };
    };
}
