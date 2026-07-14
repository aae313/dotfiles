_: {
  flake.nixosModules.audio =
    { ... }:
    {
      environment.variables = {
        SDL_AUDIODRIVER = "pipewire";
        ALSOFT_DRIVERS = "pipewire";
      };

      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        audio.enable = true;
        wireplumber.enable = true;
        pulse.enable = true;
        jack.enable = true;
      };
    };
}
