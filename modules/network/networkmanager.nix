_: {
  networking.networkmanager.enable = true;

  systemd.network.wait-online.enable = false;

  services.resolved.enable = true;
}
