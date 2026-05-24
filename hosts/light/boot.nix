{
  boot = {

    swraid.enable = false;
    kernelParams = [
      "mitigations=off"
      "nowatchdog"
      "zswap.enabled=0"
    ];

    initrd = {
      systemd.enable = true;
      supportedFilesystems = [
        "btrfs"
        "ext4"
        "tmpfs"
        "vfat"
      ];
    };
    loader = {
      timeout = 20;
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = false;
      limine = {
        enable = true;
        maxGenerations = 8;
      };
    };
    # binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

}
