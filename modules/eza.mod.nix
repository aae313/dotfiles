_: {
  flake.nixosModules.eza =
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
      environment.systemPackages = singleton pkgs.eza;

      hjem.users.${user.name}.xdg.config.files."eza/theme.yml".source = ../files/.config/eza/theme.yml;
    };
}
