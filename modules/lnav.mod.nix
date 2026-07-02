_: {
  flake.nixosModules.lnav =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe;

      inherit (config.local) user;
    in
    {
      environment.sessionVariables = {
        SYSTEMD_PAGER = "${getExe pkgs.lnav} -q";
        SYSTEMD_PAGERSECURE = "false";
      };

      hjem.users.${user.name}.packages = singleton pkgs.lnav;
    };
}
