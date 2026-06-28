_: {
  flake.nixosModules.bluetooth = {
    hardware.bluetooth = {
      enable = false;
      powerOnBoot = false;
    };

    boot.blacklistedKernelModules = [
      "bluetooth"
      "btusb"
      "ath3k"
    ];
  };
}
