{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.lists) singleton;
  inherit (lib.meta) getExe;

  home = config.users.users.wasd.home;

  configureChezmoi = pkgs.writeShellApplication {
    name = "configure-chezmoi";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.gnugrep
      pkgs.gnused
    ];
    text = /* bash */ ''
      configDir=${home}/.config/chezmoi
      config="$configDir/chezmoi.toml"
      sourceLine='sourceDir = "${home}/.local/share/nixos"'

      install -d -m0755 -o wasd -g users "$configDir"

      if ! test -e "$config"; then
        install -Dm0644 -o wasd -g users /dev/null "$config"
      fi

      if grep -qxF "$sourceLine" "$config"; then
        :
      elif grep -q '^sourceDir[[:space:]]*=' "$config"; then
        sed -i "s|^sourceDir[[:space:]]*=.*|$sourceLine|" "$config"
      else
        printf '\n%s\n' "$sourceLine" >> "$config"
      fi

      chown wasd:users "$config"
      chmod 0644 "$config"
    '';
  };
in
{
  environment.systemPackages = singleton pkgs.chezmoi;

  system.activationScripts.chezmoiConfig = {
    deps = singleton "users";
    text = getExe configureChezmoi;
  };
}
