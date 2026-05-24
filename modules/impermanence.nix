{ inputs, lib, ... }:
let
  inherit (lib.lists) forEach singleton;
in
{
  imports = singleton inputs.impermanence.nixosModule;

  environment.persistence."/persist" = {
    hideMounts = true;
    directories =
      forEach [
        "nix"
        "ssh"
        # "NetworkManager/system-connections"
      ] (x: "/etc/${x}")
      ++ forEach [
        "nixos"
        "systemd/coredump"
        #"fail2ban"
      ] (x: "/var/lib/${x}");
    files = singleton "/etc/machine-id";
  };
}
