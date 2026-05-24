{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.lists) singleton;
in
{
  environment = {
    shells = singleton pkgs.nushell;
  };

  programs = {
    fuse.userAllowOther = true;
    dconf.enable = true;
    fish.enable = true;
    nh = {
      enable = true;
      flake = "/home/wasd/.local/share/nixos";
    };

    nano.enable = false;
  };

  users = {
    mutableUsers = false;
    users = {
      wasd = {
        isNormalUser = true;
        hashedPasswordFile = "/persist/passwd";
        shell = pkgs.nushell;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMqPLz1VVjaPGsWaeAUnajDs/1awhmQLluvf+J+O9BOa light"
        ];
        extraGroups = [
          "input"
          "i2c-dev"
          "libvirtd"
          "video"
          "wheel"
          "systemd-journal"
          "plugdev"
        ];
      };
    };

    groups.plugdev = { };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo = {
      wheelNeedsPassword = false;
      execWheelOnly = true;
    };
  };
}
