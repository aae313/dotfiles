_: {
  flake.nixosModules.ov =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;

      inherit (config.local) user;
      inherit (config.local.theme) palette;

      rainbow = map (color: { Foreground = "#${color}"; }) [
        palette.fgMain
        palette.fgAlt
        palette.magenta
        palette.magentaCooler
        palette.red
        palette.redCooler
        palette.yellowWarmer
        palette.yellow
        palette.green
        palette.greenCooler
        palette.cyan
        palette.cyanCooler
        palette.blue
        palette.blueWarmer
      ];

      yaml = pkgs.formats.yaml { };
    in
    {
      environment.sessionVariables.MANPAGER = "ov --section-delimiter '^[^\\\\s]' --section-header";

      hjem.users.${user.name} = {
        packages = singleton pkgs.ov;

        xdg.config.files."ov/config.yaml" = {
          generator = yaml.generate "ov-config.yaml";
          value.Style = {
            Header = {
              Bold = true;
              Foreground = "#${palette.magentaCooler}";
              Background = "#${palette.bgMagentaNuanced}";
            };
            Body = {
              Foreground = "#${palette.fgMain}";
              Background = "#${palette.bgMain}";
            };
            Alternate.Background = "#${palette.bgInactive}";
            LineNumber = {
              Bold = true;
              Background = "#${palette.bgDim}";
            };
            SearchHighlight.Reverse = true;
            ColumnHighlight.Reverse = true;
            MarkLine = {
              Italic = true;
              Foreground = "#${palette.redCooler}";
            };
            SectionLine.Background = "#${palette.bgMagentaIntense}";
            Ruler = {
              Foreground = "#${palette.yellowWarmer}";
              Bold = true;
            };
            MultiColorHighlight = rainbow;
            ColumnRainbow = rainbow;
          };
        };
      };
    };
}
