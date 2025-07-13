{ config, pkgs, userSettings, ... }:

{
    programs.git = {
        enable = true;
        userName = "JF-Morin";
        userEmail = userSettings.email; 
    };
}
