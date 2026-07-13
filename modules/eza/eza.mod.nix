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
      inherit (lib.strings) fileContents;

      inherit (config.local) user;
      inherit (config.local.theme) palette;
    in
    {
      hjem.users.${user.name} = {
        packages = singleton pkgs.eza;

        xdg.config.files."eza/theme.yml".text =
          /* yaml */ ''
            # Modus Vivendi
            colourful: true

            define: &fg_main "#${palette.fgMain}"
            define: &fg_dim "#${palette.fgDim}"
            define: &red "#${palette.red}"
            define: &green "#${palette.green}"
            define: &yellow_warmer "#${palette.yellowWarmer}"
            define: &blue "#${palette.blue}"
            define: &blue_warmer "#${palette.blueWarmer}"
            define: &magenta "#${palette.magenta}"
            define: &magenta_cooler "#${palette.magentaCooler}"
            define: &cyan "#${palette.cyan}"
            define: &rust "#${palette.rust}"
            define: &pink "#${palette.pink}"

          ''
          + fileContents ./theme.yml;
      };
    };
}
