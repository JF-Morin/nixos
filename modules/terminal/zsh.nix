{ config, pkgs, userSettings, ... } :

{
    programs.zsh = {
        enable = true;
        histSize = 1000;
        promptInit = ''
            fastfetch
            eval "$(oh-my-posh init zsh --config ~/.oh-my-posh/jf_morin.omp.json)"
            eval "$(zoxide init zsh)"
        '';
        shellAliases = {
            # Nixos, flakes and home-manager
            nrsf = "sudo nixos-rebuild switch --flake";
            hmsf = "home-manager switch --flake";

            # LS & tree
            ls = "eza";
            ll = "eza -la";
            tree = "eza --tree";
        };
    };
}
