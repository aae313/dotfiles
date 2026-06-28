_: {
  flake.nixosModules.zathura =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;

      inherit (config.local) user;
      inherit (config.local.theme) fonts;
    in
    {
      hjem.users.${user.name} = {
        packages = singleton pkgs.zathura;

        xdg.config.files."zathura/zathurarc".text = ''
          set selection-clipboard clipboard
          set font "${fonts.mono} 12"
        '';
      };
    };
}
