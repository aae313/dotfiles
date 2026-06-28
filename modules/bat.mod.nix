_: {
  flake.nixosModules.bat =
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
      environment.sessionVariables = {
        PAGER = "bat";
        BAT_PAGER = "ov -F -H3";
      };

      environment.systemPackages = singleton pkgs.bat;

      hjem.users.${user.name}.xdg.config.files = {
        "bat/config".text = ''
          --style="plain"
          --theme=modus
          --wrap=never
        '';

        "bat/themes/catppuccin.tmTheme".source = ../files/.config/bat/themes/catppuccin.tmTheme;
        "bat/themes/modus.tmTheme".source = ../files/.config/bat/themes/modus.tmTheme;
      };
    };
}
