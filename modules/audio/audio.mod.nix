_: {
  flake.nixosModules.audio =
    { lib, ... }:
    let
      inherit (lib.strings) fileContents;
    in
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

      services.udev.extraRules = fileContents ./99-cpu-dma-latency.rules;
    };
}
