_: {
  flake.nixosModules.fuzzel =
    {
      config,
      ...
    }:
    let
      inherit (config.local) user;
      inherit (config.local.theme) fonts palette;
    in
    {
      hjem.users.${user.name}.rum.programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            font = "${fonts.mono}:size=14";
            terminal = "kitty -e";
            layer = "overlay";
            launch-prefix = "'app2unit --fuzzel-compat --'";
            prompt = "'>> '";
            width = 60;
            lines = 20;
            line-height = 24;
            vertical-pad = 8;
            horizontal-pad = 14;
            inner-pad = 8;
          };

          colors = {
            background = "#${palette.bgMain}ff";
            text = "#${palette.fgMain}ff";
            message = "#${palette.fgAlt}ff";
            prompt = "#${palette.blue}ff";
            placeholder = "#${palette.fgDim}ff";
            input = "#${palette.fgMain}ff";
            match = "#${palette.yellow}ff";
            selection = "#2f447fff";
            selection-text = "#${palette.fgMain}ff";
            selection-match = "#${palette.yellow}ff";
            counter = "#${palette.fgDim}ff";
            border = "#${palette.blue}ff";
          };

          dmenu.exit-immediately-if-empty = "yes";

          border = {
            width = 2;
            radius = 0;
          };
        };
      };
    };
}
