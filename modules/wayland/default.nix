{
  pkgs,
  ...
}:
{
  imports = [
    ./greetd.nix
    ./hyprland.nix
    ./wallpaper.nix
    ./notifications.nix
    ./xdg.nix
  ];

  environment.systemPackages = [
    pkgs.brightnessctl
    pkgs.cliphist
    pkgs.libnotify
    pkgs.fuzzel
    pkgs.grim
    pkgs.pyprland
    pkgs.python3
    pkgs.satty
    pkgs.slurp
    pkgs.wl-clipboard
    pkgs.eww
  ];

  environment.sessionVariables = {
    DISABLE_QT_COMPAT = "0";
    GDK_BACKEND = "wayland";
    GDK_SCALE = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
    _JAVA_AWT_WM_NONEREPARENTING = "1";
    GTK2_RC_FILES = "/home/wasd/.config/gtk-2.0/gtkrc";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
  };
}
