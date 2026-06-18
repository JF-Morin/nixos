{ config, pkgs, user, ... }:

{
    programs.gh = {
        enable = true;
        gitCredentialHelper.enable = true;
    };
}
