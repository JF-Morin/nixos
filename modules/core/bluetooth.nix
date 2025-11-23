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
    services.blueman.enable = true;
}
