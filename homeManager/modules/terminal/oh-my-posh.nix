{ config, pkgs, lib, ... }:

{
    programs.oh-my-posh = {
        enable = true;
        enableZshIntegration = false;
    };

    home.file.".config/oh-my-posh/jf_morin.omp.json".source = ./jf_morin.omp.json;
}
