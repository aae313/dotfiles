{
  imports = [
    ../../profiles/workstation
    ../common/base.nix
    ../common/boot.nix
    ../common/impermanent-btrfs.nix
    ./kernel.nix
    ./laptop.nix
  ];
}
