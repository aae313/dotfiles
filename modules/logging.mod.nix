_: {
  flake.nixosModules.logging = {
    services.journald.extraConfig = /* systemd */ ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
  };
}
