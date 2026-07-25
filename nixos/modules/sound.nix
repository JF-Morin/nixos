{ config, pkgs, ... }: 

{
    # Enable sound with pipewire.
    services.pulseaudio.enable = false; # For older applications, pipewire.pulse is used instead
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true; # If you want to use JACK applications, uncomment this
        wireplumber.enable = true;
    };
}
