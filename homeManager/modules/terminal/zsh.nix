{ config, pkgs, userSettings, ... } :

{
    programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        history = {
            size = 1000;
        };
        initContent = ''
            eval "$(zoxide init zsh)"
            eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/jf_morin.omp.json)"
        '';
        shellAliases = {
            # Nixos, flakes and home-manager
            nrsf = "sudo nixos-rebuild switch --flake";
            hmsf = "home-manager switch --flake";

            # LS & tree
            ls = "eza --icons=auto";
            ll = "eza -la --icons=auto";
            tree = "eza --tree --icons=auto";
        };
    };
}
