_: {
  flake.nixosModules.security = {
    programs.fuse.userAllowOther = true;

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
