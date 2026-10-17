{ config, pkgs, ... } :

{
    imports = [
        ./hyprland.nix
        ./hypridle.nix
        ./hyprlock.nix
        ./noctalia.nix
    ];
}
