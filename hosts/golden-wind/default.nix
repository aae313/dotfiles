{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./cpu.nix
  ];

  system.stateVersion = "26.05";
}
