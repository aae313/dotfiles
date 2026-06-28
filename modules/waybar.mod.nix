_: {
  flake.nixosModules.waybar =
    {
      config,
      ...
    }:
    let
      inherit (config.local) user;
    in
    {
      programs.waybar.enable = true;

      hjem.users.${user.name}.xdg.config.files = {
        # Kept as a source file: the upstream config embeds Nerd Font glyphs that
        # do not survive hand-inlining.
        "waybar/config.jsonc".source = ../files/.config/waybar/config.jsonc;

        "waybar/style.css".source = ../files/.config/waybar/style.css;
        "waybar/nixos.svg".source = ../files/.config/waybar/nixos.svg;

        "waybar/waybar-niri-taskbar" = {
          source = ../files/.config/waybar/waybar-niri-taskbar;
          executable = true;
        };
      };
    };
}
