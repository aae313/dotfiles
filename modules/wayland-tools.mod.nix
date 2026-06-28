_: {
  flake.nixosModules.wayland-tools =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.cliphist
        pkgs.dex
        pkgs.libnotify
        pkgs.wl-clipboard
        pkgs.grim
        pkgs.slurp
        pkgs.satty
      ];
    };
}
