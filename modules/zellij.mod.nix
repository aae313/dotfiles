_: {
  flake.nixosModules.zellij =
    {
      config,
      lib,
      linkConfigDir,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;

      inherit (config.local) user;
    in
    {
      environment.systemPackages = singleton pkgs.zellij;

      hjem.users.${user.name}.xdg.config.files = linkConfigDir "zellij";
    };
}
