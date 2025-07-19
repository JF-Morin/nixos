{ config, pkgs, ... } : 

{
    imports = [
        ./hyprlock.nix
        ./ags.nix
    ];
}
