{
  inputs,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib.lists) singleton;
  inherit (lib.meta) getExe;

  chatgptWebapp = pkgs.writeShellApplication {
    name = "chatgpt-webapp";
    text = /* bash */ ''
      state_home="''${XDG_STATE_HOME:-$HOME/.local/state}"
      profile_dir="$state_home/chromium-chatgpt"

      mkdir -p "$profile_dir"

      exec ${getExe pkgs.chromium} \
        --app=https://chatgpt.com \
        --class=chatgpt \
        --name=chatgpt \
        --user-data-dir="$profile_dir"
    '';
  };

  chatgptDesktop = pkgs.makeDesktopItem {
    name = "chatgpt-webapp";
    desktopName = "ChatGPT";
    exec = getExe chatgptWebapp;
    categories = singleton "Network";
    startupWMClass = "chrome-chatgpt.com__-Default";
  };
in
{
  environment.systemPackages = [
    pkgs.anki
    chatgptDesktop
    chatgptWebapp
    pkgs.imv
    # pkgs.mpv
    pkgs.obsidian
    pkgs.pwvucontrol
    pkgs.ticktick
    pkgs.vesktop
    pkgs.zathura
  ];
}
