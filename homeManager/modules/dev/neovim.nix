{ config, pkgs, lib, ... }:

{
    home.packages = with pkgs; [
        neovim
        ripgrep  # live grep (snacks, telescope)
        fd       # file finder
    ];
    # gcc and gnumake (treesitter) are already provided by dev-tools.nix

    home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
    };

    home.shellAliases = {
        vi  = "nvim";
        vim = "nvim";
    };

    # Symlink ~/.config/nvim directly to the dotfiles directory so lua files
    # remain editable without rebuilding. Runs after HM writes its own files
    # so there is no conflict with programs.neovim-generated init.lua.
    home.activation.linkNeovimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ln -sfn "${config.home.homeDirectory}/Projects/nixos/dotfiles/neovim/.config/nvim" \
            "${config.xdg.configHome}/nvim"
    '';
}
