{ config, ... }:
let
  inherit (config.flake.lib) linkConfigDir;
in
{
  flake.nixosModules.waybar =
    {
      config,
      ...
    }:
    let
      inherit (config.local) user;
      inherit (config.local.theme) fonts palette;
    in
    {
      programs.waybar.enable = true;

      systemd.user.services.waybar.path =
        config.environment.systemPackages ++ config.users.users.${user.name}.packages;

      hjem.users.${user.name}.xdg.config.files = linkConfigDir ./config "waybar" // {
        "waybar/theme.css".text = /* css */ ''
          @define-color red #${palette.red};
          @define-color blue #${palette.blue};
          @define-color cyan #${palette.cyan};
          @define-color text #${palette.fgMain};
          @define-color subtext #${palette.fgDim};
          @define-color surface #${palette.bgInactive};
          @define-color base #${palette.bgDim};
          @define-color crust #${palette.bgMain};

          @define-color bar-bg alpha(@crust, 0.82);
          @define-color workspace-bg @surface;
          @define-color workspace-empty @base;
          @define-color workspace-fg @subtext;
          @define-color workspace-active-bg @blue;
          @define-color workspace-active-fg @crust;
          @define-color workspace-hover-bg @cyan;
          @define-color workspace-urgent-bg @red;

          * {
            font-family: "${fonts.mono}", "${fonts.symbols}", "${fonts.sans}", sans-serif;
          }
        '';
      };
    };
}
