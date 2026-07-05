_: {
  flake.nixosModules.user =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;
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

        flakeDir = mkOption {
          type = str;
          default = "${config.local.user.home}/nixos";
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

      config.users = {
        mutableUsers = false;
        users.${user.name} = {
          isNormalUser = true;
          hashedPasswordFile = "/persist/passwd";
          shell = pkgs.fish;
          openssh.authorizedKeys.keys = singleton "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMqPLz1VVjaPGsWaeAUnajDs/1awhmQLluvf+J+O9BOa light";
          extraGroups = [
            "ydotool"
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
