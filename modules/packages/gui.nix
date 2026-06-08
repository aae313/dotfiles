{
  inputs,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib.lists) singleton;
  inherit (lib.meta) getExe;

  helium = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default;

  chatgptExporterExtension = pkgs.callPackage (
    {
      fetchurl,
      libarchive,
      runCommand,
    }:
    runCommand "chatgpt-exporter-extension-6.4.0"
      {
        nativeBuildInputs = singleton libarchive;
        src = fetchurl {
          url = "https://clients2.google.com/service/update2/crx?response=redirect&prodversion=122.0.0.0&acceptformat=crx2,crx3&x=id%3Dilmdofdhpnhffldihboadndccenlnfll%26installsource%3Dondemand%26uc";
          hash = "sha256-YNlnLFzCiRznuarIleHk8CgrppP/OdRd6VD499gSLVo=";
        };
      }
      /* bash */ ''
        mkdir -p "$out"
        bsdtar -xf "$src" -C "$out"
        substituteInPlace "$out/background.js" \
          --replace-fail 'chrome.tabs.create({url:c.web.welcome}),' ""
        rm -rf "$out/_metadata"
      ''
  ) { };

  chatgptWebapp = pkgs.writeShellApplication {
    name = "chatgpt-webapp";
    text = /* bash */ ''
      state_home="''${XDG_STATE_HOME:-$HOME/.local/state}"
      profile_dir="$state_home/helium-chatgpt"

      mkdir -p "$profile_dir"

      exec ${getExe helium} \
        --app=https://chatgpt.com \
        --class=chatgpt \
        --load-extension=${chatgptExporterExtension} \
        --name=chatgpt \
        --user-data-dir="$profile_dir"
    '';
  };

  chatgptDesktop = pkgs.makeDesktopItem {
    name = "chatgpt-webapp";
    desktopName = "ChatGPT";
    exec = getExe chatgptWebapp;
    categories = singleton "Network";
    startupWMClass = "chatgpt";
  };

  claudeWebapp = pkgs.writeShellApplication {
    name = "claude-webapp";
    text = /* bash */ ''
      state_home="''${XDG_STATE_HOME:-$HOME/.local/state}"
      profile_dir="$state_home/helium-claude"

      mkdir -p "$profile_dir"

      exec ${getExe helium} \
        --app=https://claude.ai \
        --class=claude \
        --name=claude \
        --user-data-dir="$profile_dir"
    '';
  };

  claudeDesktop = pkgs.makeDesktopItem {
    name = "claude-webapp";
    desktopName = "Claude";
    exec = getExe claudeWebapp;
    categories = singleton "Network";
    startupWMClass = "claude";
  };

in
{
  environment.systemPackages = [
    pkgs.anki
    chatgptDesktop
    chatgptWebapp
    claudeDesktop
    claudeWebapp
    pkgs.imv
    pkgs.obsidian
    helium
    pkgs.pwvucontrol_git
    pkgs.ticktick
    pkgs.vesktop
    pkgs.zathura
    pkgs.kitty
  ];
}
