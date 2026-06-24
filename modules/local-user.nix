{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) str;
in
{
  options.local.user = {
    name = mkOption {
      type = str;
      default = "wasd";
    };

    home = mkOption {
      type = str;
      default = "/home/${config.local.user.name}";
    };
  };
}
