{ config, pkgs, userSettings, systemSettings, ... }:

{
    imports = [
        ./shared.home.nix
    ];
    
    # Specific programs for Desktop
    home.packages = with pkgs; [
        # Applications
        brightnessctl
    ];
}
