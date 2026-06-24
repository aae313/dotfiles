{
  lib,
  buildNimPackage,
  fetchFromGitHub,
}:
buildNimPackage {
  pname = "tridactyl-native";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "tridactyl";
    repo = "native_messenger";
    rev = "a5066041c50781e7aae077fac1dc3c600e33b692";
    hash = "sha256-lOBiWLQp28jIxrmYDYnNfxfFXmSgneKU4ZrHpoHZ9ik=";
  };

  lockFile = ./lock.json;

  installPhase = /* bash */ ''
    mkdir -p "$out/lib/mozilla/native-messaging-hosts"
    sed -i -e "s|REPLACE_ME_WITH_SED|$out/bin/native_main|" tridactyl.json
    cp tridactyl.json "$out/lib/mozilla/native-messaging-hosts/"
  '';

  meta = {
    description = "Native messenger for Tridactyl, a vim-like Firefox webextension";
    mainProgram = "native_main";
    homepage = "https://github.com/tridactyl/native_messenger";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
  };
}
