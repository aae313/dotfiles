_: {
  flake.nixosModules.chezmoi =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe;

      inherit (config.local) user;

      configureChezmoi = pkgs.writeShellApplication {
        name = "configure-chezmoi";
        runtimeInputs = [
          pkgs.coreutils
          pkgs.gnugrep
          pkgs.gnused
        ];
        text = /* bash */ ''
          configDir=${user.home}/.config/chezmoi
          config="$configDir/chezmoi.toml"
          sourceLine='sourceDir = "${user.home}/.local/share/nixos"'

          install -d -m0755 -o ${user.name} -g users "$configDir"

          if ! test -e "$config"; then
            install -Dm0644 -o ${user.name} -g users /dev/null "$config"
          fi

          if grep -qxF "$sourceLine" "$config"; then
            :
          elif grep -q '^sourceDir[[:space:]]*=' "$config"; then
            sed -i "s|^sourceDir[[:space:]]*=.*|$sourceLine|" "$config"
          else
            printf '\n%s\n' "$sourceLine" >> "$config"
          fi

          chown ${user.name}:users "$config"
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
    };
}
