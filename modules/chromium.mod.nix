_: {
  flake.nixosModules.chromium =
    { config, ... }:
    let
      inherit (config.local) user;
    in
    {
      hjem.users.${user.name}.xdg.config.files."chromium-flags.conf".text = ''
        --ignore-gpu-blocklist
        --enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoEncoder
        --ozone-platform=wayland
        --ozone-platform-hint=wayland
        --force-device-scale-factor=0.8
        --no-first-run
        --no-default-browser-check
        --disable-features=MediaRouter
      '';
    };
}
