_: {
  flake.nixosModules.waybar =
    {
      config,
      pkgs,
      ...
    }:
    let
      inherit (config.local) user;
    in
    {
      programs.waybar.enable = true;

      systemd.user.services.waybar.path = [
        config.programs.niri.package
        pkgs.jq
      ];

      hjem.users.${user.name}.xdg.config.files = {
        "waybar/config.jsonc".source = ./config.jsonc;
        "waybar/style.css".source = ./style.css;
        "waybar/nixos.svg".source = ./nixos.svg;
        "waybar/waybar-niri-taskbar" = {
          source = ./waybar-niri-taskbar;
          executable = true;
        };
      };
    };
}
