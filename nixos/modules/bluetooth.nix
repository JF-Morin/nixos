{ config, pkgs, ... }: 

{
    # Enable bluetooth
    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
            General = {
                Experimental = true;
                FastConnectable = true;
            };
        };

    };
    # Not needed because of noctalia
    # services.blueman.enable = true;
}
