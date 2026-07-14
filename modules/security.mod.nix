_: {
  flake.nixosModules.security = {
    programs.fuse = {
      enable = true;
      userAllowOther = true;
    };

    security = {
      polkit.enable = true;
      rtkit.enable = true;
      sudo = {
        wheelNeedsPassword = false;
        execWheelOnly = true;
      };
    };
  };
}
