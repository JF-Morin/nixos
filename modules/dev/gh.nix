{ config, pkgs, userSettings, ... }:

{
    programs.gh = {
        enable = true;
        gitCredentialHelper.enable = true;
    };
}
