{
  lib,
  config,
  ...
}:
let
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkDefault;
in
{
  boot.kernelModules = singleton "kvm-amd";

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;
  };
}
