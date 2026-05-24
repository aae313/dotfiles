{
  lib,
  config,
  ...
}:
let
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkDefault;
in
{

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];
    kernelModules = singleton "kvm-amd";

    extraModulePackages = [ ];
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;
    graphics = {
      enable = true;
      # enable32Bit = true;
      extraPackages = [
        # pkgs.libva-mesa-driver
        # pkgs.mesa-vdpau
      ];
      extraPackages32 = [
        # pkgs.driversi686Linux.libva-mesa-driver
      ];
    };
  };
}
