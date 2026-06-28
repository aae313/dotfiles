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
        BAT_PAGER = "ov --follow-section --header 3";
      };

      hjem.users.${user.name} = {
        packages = singleton pkgs.bat;

        xdg.config.files = {
          "bat/config".text = ''
            --style="plain"
            --theme=modus
            --wrap=never
          '';

          "bat/themes/catppuccin.tmTheme".source = ./themes/catppuccin.tmTheme;
          "bat/themes/modus.tmTheme".source = ./themes/modus.tmTheme;
        };
      };
    };
}
