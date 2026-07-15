_: {
  flake.nixosModules.theme =
    { lib, ... }:
    let
      inherit (lib.options) mkOption;
      inherit (lib.types) attrsOf str;
    in
    {
      options.local.theme.palette = mkOption {
        type = attrsOf str;
        default = { };
      };

      config.local.theme.palette = {
        fgMain = "ffffff";
        fgAlt = "c6daff";
        fgDim = "989898";

        bgMain = "000000";
        bgMainTinted = "0d0e1c";
        bgDim = "1e1e1e";
        bgInactive = "303030";
        bgActive = "535353";
        bgSelection = "7030af";

        border = "646464";

        red = "ff5f59";
        redWarmer = "ff6b55";
        redCooler = "ff7f86";
        redFaint = "ff9580";
        redIntense = "ff5f5f";

        green = "44bc44";
        greenWarmer = "70b900";
        greenCooler = "00c06f";
        greenFaint = "88ca9f";
        greenIntense = "44df44";

        yellow = "d0bc00";
        yellowWarmer = "fec43f";
        yellowCooler = "dfaf7a";
        yellowFaint = "d2b580";
        yellowIntense = "efef00";

        blue = "2fafff";
        blueWarmer = "79a8ff";
        blueCooler = "00bcff";
        blueFaint = "82b0ec";
        blueIntense = "338fff";

        magenta = "feacd0";
        magentaWarmer = "f78fe7";
        magentaCooler = "b6a0ff";
        magentaFaint = "caa6df";
        magentaIntense = "ff66ff";

        cyan = "00d3d0";
        cyanWarmer = "4ae2f0";
        cyanCooler = "6ae4b9";
        cyanFaint = "9ac8e0";
        cyanIntense = "00eff0";

        rust = "db7b5f";
        gold = "c0965b";
        olive = "9cbd6f";
        slate = "76afbf";
        indigo = "9099d9";
        maroon = "cf7fa7";
        pink = "d09dc0";

        bgRedIntense = "9d1f1f";
        bgGreenIntense = "2f822f";
        bgYellowIntense = "7a6100";
        bgBlueIntense = "1640b0";
        bgMagentaIntense = "7030af";
        bgCyanIntense = "2266ae";

        bgRedSubtle = "620f2a";
        bgGreenSubtle = "00422a";
        bgYellowSubtle = "4a4000";
        bgBlueSubtle = "242679";
        bgMagentaSubtle = "552f5f";
        bgCyanSubtle = "004065";

        bgRedNuanced = "3a0c14";
        bgGreenNuanced = "092f1f";
        bgYellowNuanced = "381d0f";
        bgBlueNuanced = "12154a";
        bgMagentaNuanced = "2f0c3f";
        bgCyanNuanced = "042837";

        bgClay = "49191a";
        fgClay = "f1b090";

        bgOchre = "462f20";
        fgOchre = "e0d09c";

        bgLavender = "38325c";
        fgLavender = "dfc0f0";

        bgSage = "143e32";
        fgSage = "c3e7d4";

        bgGraphRed0 = "b52c2c";
        bgGraphRed1 = "702020";
        bgGraphGreen0 = "0fed00";
        bgGraphGreen1 = "007800";
        bgGraphYellow0 = "f1e00a";
        bgGraphYellow1 = "b08940";
        bgGraphBlue0 = "2fafef";
        bgGraphBlue1 = "1f2f8f";
        bgGraphMagenta0 = "bf94fe";
        bgGraphMagenta1 = "5f509f";
        bgGraphCyan0 = "47dfea";
        bgGraphCyan1 = "00808f";

        bgCompletion = "2f447f";
        bgHover = "45605e";
        bgHoverSecondary = "654a39";
        bgHlLine = "2f3849";
        bgRegion = "5a5a5a";
        fgRegion = "ffffff";

        bgModeLineActive = "505050";
        fgModeLineActive = "ffffff";
        borderModeLineActive = "959595";

        bgModeLineInactive = "2d2d2d";
        fgModeLineInactive = "969696";
        borderModeLineInactive = "606060";

        modelineErr = "ffa9bf";
        modelineWarning = "dfcf43";
        modelineInfo = "9fefff";

        bgTabBar = "313131";
        bgTabCurrent = "000000";
        bgTabOther = "545454";

        bgAdded = "00381f";
        bgAddedFaint = "002910";
        bgAddedRefine = "034f2f";
        bgAddedFringe = "237f3f";
        fgAdded = "a0e0a0";
        fgAddedIntense = "80e080";

        bgChanged = "363300";
        bgChangedFaint = "2a1f00";
        bgChangedRefine = "4a4a00";
        bgChangedFringe = "8a7a00";
        fgChanged = "efef80";
        fgChangedIntense = "c0b05f";

        bgRemoved = "4f1119";
        bgRemovedFaint = "380a0f";
        bgRemovedRefine = "781a1f";
        bgRemovedFringe = "b81a1f";
        fgRemoved = "ffbfbf";
        fgRemovedIntense = "ff9095";

        bgDiffContext = "1a1a1a";
        bgParenMatch = "2f7f9f";
        bgParenExpression = "453040";

        termBlack = "000000";
        termBrightBlack = "595959";
        termWhite = "a6a6a6";
        termBrightWhite = "ffffff";
      };
    };

  flake.nixosModules.fonts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;
      inherit (lib.options) mkOption;
      inherit (lib.types) str;

      inherit (config.local.theme) fonts;
    in
    {
      options.local.theme.fonts = {
        mono = mkOption {
          type = str;
          default = "JetBrainsMono Nerd Font";
        };

        sans = mkOption {
          type = str;
          default = "Inter";
        };

        symbols = mkOption {
          type = str;
          default = "Symbols Nerd Font";
        };

        emoji = mkOption {
          type = str;
          default = "Noto Color Emoji";
        };
      };

      config.fonts = {
        packages = [
          pkgs.material-symbols
          pkgs.noto-fonts

          pkgs.noto-fonts-color-emoji
          pkgs.roboto
          (pkgs.google-fonts.override { fonts = singleton "Inter"; })
          pkgs.jetbrains-mono
          pkgs.nerd-fonts.jetbrains-mono
          pkgs.nerd-fonts.symbols-only
        ];

        enableDefaultPackages = false;

        fontconfig.defaultFonts = {
          serif = singleton fonts.sans;
          sansSerif = singleton fonts.sans;
          monospace = singleton fonts.mono;
          emoji = singleton fonts.emoji;
        };

        fontconfig.localConf = /* xml */ ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
          <fontconfig>
            <alias binding="strong">
              <family>sans-serif</family>
              <prefer>
                <family>${fonts.sans}</family>
              </prefer>
            </alias>
            <alias binding="strong">
              <family>system-ui</family>
              <prefer>
                <family>${fonts.sans}</family>
              </prefer>
            </alias>
            <alias binding="strong">
              <family>ui-sans-serif</family>
              <prefer>
                <family>${fonts.sans}</family>
              </prefer>
            </alias>
          </fontconfig>
        '';
      };
    };
}
