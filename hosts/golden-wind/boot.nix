{
  boot = {
    initrd.supportedFilesystems = [
      "btrfs"
      "ext4"
      "tmpfs"
      "vfat"
    ];
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
}
