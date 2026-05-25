{ lib, pkgs, ... }:
let
  inherit (lib.lists) singleton;
in
{
  environment.systemPackages = singleton pkgs.chezmoi;

  system.activationScripts.chezmoiConfig.text = /* bash */ ''
    configDir=/home/wasd/.config/chezmoi
    config="$configDir/chezmoi.toml"
    sourceLine='sourceDir = "/home/wasd/.local/share/nixos"'

    ${pkgs.coreutils}/bin/install -d -m0755 -o wasd -g users "$configDir"

    if ! ${pkgs.coreutils}/bin/test -e "$config"; then
      ${pkgs.coreutils}/bin/install -Dm0644 -o wasd -g users /dev/null "$config"
    fi

    if ${pkgs.gnugrep}/bin/grep -qxF "$sourceLine" "$config"; then
      :
    elif ${pkgs.gnugrep}/bin/grep -q '^sourceDir[[:space:]]*=' "$config"; then
      ${pkgs.gnused}/bin/sed -i "s|^sourceDir[[:space:]]*=.*|$sourceLine|" "$config"
    else
      ${pkgs.coreutils}/bin/printf '\n%s\n' "$sourceLine" >> "$config"
    fi

    ${pkgs.coreutils}/bin/chown wasd:users "$config"
    ${pkgs.coreutils}/bin/chmod 0644 "$config"
  '';
}
