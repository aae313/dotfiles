_: {
  flake.nixosModules.foot =
    {
      config,
      ...
    }:
    let
      inherit (config.local) user;
      inherit (config.local.theme) fonts palette;
    in
    {
      programs.foot = {
        enable = true;
        xdg.serverAutostart = true;
      };

      hjem.users.${user.name}.xdg.config.files."foot/foot.ini".text = /* ini */ ''
        [main]
        box-drawings-uses-font-glyphs=yes
        locked-title=no
        shell=fish
        font=${fonts.mono}:size=12

        [cursor]
        style=beam
        beam-thickness=2

        [bell]
        urgent=yes
        notify=yes

        [key-bindings]
        show-urls-launch=Control+Shift+u
        unicode-input=Control+Shift+i
        # search-start=Control+f


        [colors-dark]
        cursor=${palette.fgMain} 44df44
        foreground=${palette.fgMain}
        background=${palette.bgMain}
        selection-foreground=${palette.fgMain}
        selection-background=${palette.bgSelection}
        urls=${palette.fgAlt}

        regular0=${palette.bgMain}
        regular1=${palette.red}
        regular2=${palette.green}
        regular3=${palette.yellow}
        regular4=${palette.blue}
        regular5=${palette.magenta}
        regular6=${palette.cyan}
        regular7=${palette.termWhite}

        bright0=${palette.termBrightBlack}
        bright1=${palette.redWarmer}
        bright2=${palette.greenCooler}
        bright3=${palette.yellowWarmer}
        bright4=${palette.blueWarmer}
        bright5=${palette.magentaWarmer}
        bright6=${palette.cyanCooler}
        bright7=${palette.fgMain}

        16=${palette.yellowWarmer}
        17=${palette.redFaint}
      '';
    };
}
