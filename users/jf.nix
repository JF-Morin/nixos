{ config,  pkgs, userSettings, ... } :

{
    users.defaultUserShell = pkgs.zsh;
    users.users.${userSettings.username} = {
        isNormalUser = true;
        description = userSettings.name;
        extraGroups = [ "networkmanager" "wheel" ];
        shell = pkgs.zsh;
    };
}
