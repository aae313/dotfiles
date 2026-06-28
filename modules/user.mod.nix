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
