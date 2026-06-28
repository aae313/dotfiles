_: {
  flake.nixosModules.procs =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;

      inherit (config.local) user;
    in
    {
      environment.systemPackages = singleton pkgs.procs;

      hjem.users.${user.name}.xdg.config.files."procs/config.toml".source = ../files/.config/procs/config.toml;
    };
}
