_: {
  flake.nixosModules.user =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.options) mkOption;
      inherit (lib.types) str;

      inherit (config.local) user;
    in
    {
      options.local.user = {
        name = mkOption {
          type = str;
          default = "wasd";
        };

        home = mkOption {
          type = str;
          default = "/home/${config.local.user.name}";
        };

        email = mkOption {
          type = str;
          default = "230780735+aae313@users.noreply.github.com";
        };

        handle = mkOption {
          type = str;
          default = "aae313";
        };
      };

      options.local.theme.fonts = {
        mono = mkOption {
          type = str;
          default = "JetBrainsMono Nerd Font";
        };

        sans = mkOption {
          type = str;
          default = "Inter";
        };

        symbols = mkOption {
          type = str;
          default = "Symbols Nerd Font";
        };

        emoji = mkOption {
          type = str;
          default = "Noto Color Emoji";
        };
      };

      config.users = {
        mutableUsers = false;
        users.${user.name} = {
          isNormalUser = true;
          hashedPasswordFile = "/persist/passwd";
          shell = pkgs.fish;
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMqPLz1VVjaPGsWaeAUnajDs/1awhmQLluvf+J+O9BOa light"
          ];
          extraGroups = [
            "input"
            "i2c-dev"
            "libvirtd"
            "networkmanager"
            "video"
            "wheel"
            "systemd-journal"
            "plugdev"
          ];
        };

        groups.plugdev = { };
      };
    };
}
