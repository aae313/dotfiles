_: {
  flake.nixosModules.theme =
    { lib, ... }:
    let
      inherit (lib.options) mkOption;
      inherit (lib.types) attrsOf str;
    in
    {
      # Modus Vivendi. Values are bare RGB hex so each consumer can apply its
      # own prefix: "${...}" for foot, "#${...}" for kitty/mako/starship,
      # "#${...}ff" for fuzzel.
      options.local.theme.palette = mkOption {
        type = attrsOf str;
        default = { };
      };

      config.local.theme.palette = {
        fgMain = "ffffff";
        fgAlt = "c6daff";
        fgDim = "989898";

        bgMain = "000000";
        bgDim = "1e1e1e";
        bgInactive = "303030";
        bgActive = "535353";
        bgSelection = "7030af";

        border = "646464";

        red = "ff5f59";
        redWarmer = "ff6b55";
        redCooler = "ff7f86";
        redFaint = "ff9580";

        green = "44bc44";
        greenCooler = "00c06f";

        yellow = "d0bc00";
        yellowWarmer = "fec43f";
        yellowCooler = "dfaf7a";

        blue = "2fafff";
        blueWarmer = "79a8ff";
        blueCooler = "00bcff";

        cyan = "00d3d0";
        cyanCooler = "6ae4b9";

        magenta = "feacd0";
        magentaWarmer = "f78fe7";
        magentaCooler = "b6a0ff";

        indigo = "9099d9";

        termWhite = "a6a6a6";
        termBrightBlack = "595959";
      };
    };
}
