_: {
  flake.nixosModules.terminals = {
    programs.foot = {
      enable = true;
      xdg.serverAutostart = true;
    };
  };
}
