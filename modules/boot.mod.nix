_: {
  flake.nixosModules.boot =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;

      falloutBackground = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Neptune3013/fallout-limine-theme/9a777b932de07dce60e58b2a1162b7d41ecfd2e9/Fallout_limine/high-res-bg/background.png";
        hash = "sha256-Ik5P9q4JxUzam4UZSU610uh1JnYdpjEERNXEOXzLOQY=";
      };

      falloutFont = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Neptune3013/fallout-limine-theme/9a777b932de07dce60e58b2a1162b7d41ecfd2e9/Fallout_limine/PHXEGA8.F14";
        hash = "sha256-SBGsTt2cLVmWEx7EFrHFDOj5TLr+qCtwBp7t6pFiJTc=";
      };
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
            additionalFiles."PHXEGA8.F14" = falloutFont;
            enable = true;
            extraConfig = /* limine */ ''
              term_font: boot():/PHXEGA8.F14
              term_font_size: 8x14
            '';
            maxGenerations = 8;
            style = {
              wallpapers = singleton falloutBackground;

              interface = {
                branding = "";
                helpHidden = true;
              };

              graphicalTerminal = {
                font.scale = "2x2";
                background = "9935453b";
                brightBackground = "ffffff";
                foreground = "67d97a";
                palette = "000000;5c110c;074224;4d1c0d;00594d;f5c2e7;16de6d;989e9b";
                brightPalette = "2f3030;ff0000;16de6d;f7cd34;0ddeaa;f5c2e7;16de6d;ffffff";
                margin = 0;
              };
            };
          };
        };
      };
    };
}
