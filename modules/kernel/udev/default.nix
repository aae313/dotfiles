{ lib, ... }:
let
  inherit (lib.strings) fileContents;
in
{
  services.udev = {
    enable = true;
    packages = [ ];

    extraRules = fileContents ./60-ioschedulers.rules;
  };
}
