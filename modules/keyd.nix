{ lib, ... }:
let
  inherit (lib.lists) singleton;
in
{
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = singleton "*";
        settings = {
          main = {
            capslock = "esc";
            rightshift = "layer(navigation)";
            rightcontrol = "toggle(symbols)";
          };

          navigation = {
            w = "up";
            a = "left";
            s = "down";
            d = "right";
          };

          symbols = {
            "1" = "S-1";
            "2" = "S-2";
            "3" = "S-3";
            "4" = "S-4";
            "5" = "S-5";
            "6" = "S-6";
            "7" = "S-7";
            "8" = "S-8";
            "9" = "S-9";
            "0" = "S-0";
          };
        };
      };
    };
  };
}
