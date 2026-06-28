_: {
  flake.nixosModules.kernel =
    { lib, ... }:
    let
      inherit (lib.strings) fileContents;
    in
    {
      boot = {
        kernel.sysctl = {
          # Prefer swap usage under memory pressure
          "vm.swappiness" = 100;

          # Retain VFS inode/dentry cache longer
          "vm.vfs_cache_pressure" = 50;

          # Start process writeback at 256 MiB dirty data
          "vm.dirty_bytes" = 268435456;

          # Start background flusher at 64 MiB dirty data
          "vm.dirty_background_bytes" = 67108864;

          # Flusher wakeup interval (15 seconds)
          "vm.dirty_writeback_centisecs" = 1500;

          # Disable swap readahead
          "vm.page-cluster" = 0;

          # Disable NMI watchdog
          "kernel.nmi_watchdog" = 0;

          # Allow unprivileged user namespaces
          "kernel.unprivileged_userns_clone" = 1;

          # Reduce console kernel message verbosity
          "kernel.printk" = "3 3 3 3";

          # Hide kernel pointers from unprivileged users
          "kernel.kptr_restrict" = 2;

          # Increase maximum file handles
          "fs.file-max" = 2097152;
        };

        swraid.enable = false;
        initrd.systemd.enable = true;
        kernelParams = [
          "mitigations=off"
          "nowatchdog"
          "zswap.enabled=0"
        ];

        enableContainers = false;
        tmp = {
          useTmpfs = true;
          tmpfsSize = "80%";
        };
      };

      services.scx = {
        enable = true;
        scheduler = "scx_rusty";
      };

      services.udev.extraRules = fileContents ./60-ioschedulers.rules;
    };
}
