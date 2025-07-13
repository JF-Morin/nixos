{ config,  pkgs, userSettings, ... } :

{
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
    users.users.${userSettings.username} = {
        isNormalUser = true;
        description = userSettings.name;
        extraGroups = [ "networkmanager" "wheel" ];
        shell = pkgs.zsh;
    };
}
