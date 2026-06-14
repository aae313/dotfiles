{
  pkgs,
  ...
}:
{
  users = {
    mutableUsers = false;
    users = {
      wasd = {
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
          "video"
          "wheel"
          "systemd-journal"
          "plugdev"
        ];
      };
    };

    groups.plugdev = { };
  };
}
