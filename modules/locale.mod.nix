_: {
  flake.nixosModules.locale =
    { lib, ... }:
    let
      inherit (lib.modules) mkDefault;
    in
    {
      i18n =
        let
          defaultLocale = "en_US.UTF-8";
          de = "de_DE.UTF-8";
        in
        {
          inherit defaultLocale;
          extraLocaleSettings = {
            LANG = defaultLocale;
            LC_COLLATE = defaultLocale;
            LC_CTYPE = defaultLocale;
            LC_MESSAGES = defaultLocale;

            LC_ADDRESS = de;
            LC_IDENTIFICATION = de;
            LC_MEASUREMENT = de;
            LC_MONETARY = de;
            LC_NAME = de;
            LC_NUMERIC = de;
            LC_PAPER = de;
            LC_TELEPHONE = de;
            LC_TIME = de;
          };
        };

      time.timeZone = mkDefault "Europe/Berlin";
      console.keyMap = "us";
    };
}
