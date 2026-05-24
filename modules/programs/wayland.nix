{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.strings) makeBinPath;

  ns = pkgs.writeScriptBin "ns" /* bash */ ''
    #!${pkgs.runtimeShell}
    export PATH=${makeBinPath [ pkgs.niri ]}:$PATH
    exec ${getExe pkgs.python3} ${../scripts/ns} "$@"
  '';
in
{
  programs.niri.enable = true;

  environment.sessionVariables = {
    DIRENV_LOG_FORMAT = "";
    DISABLE_QT_COMPAT = "0";
    GDK_BACKEND = "wayland";
    GDK_SCALE = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";

    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    ANKI_WAYLAND = "1";
    _JAVA_AWT_WM_NONEREPARENTING = "1";

    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";

    GTK2_RC_FILES = "/home/wasd/.config/gtk-2.0/gtkrc";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
  };

  environment.systemPackages = [
    pkgs.cliphist
    pkgs.libnotify
    ns
    pkgs.polkit_gnome
    pkgs.satty
    pkgs.swaybg
    pkgs.wl-clipboard
    pkgs.xwayland-satellite
  ];
}
