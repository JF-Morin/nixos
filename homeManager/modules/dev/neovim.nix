{ config, pkgs, lib, ... }:

{
    programs.neovim = {
        enable        = true;
        defaultEditor = true;
        viAlias       = true;
        vimAlias      = true;
    };

    # Symlink ~/.config/nvim directly to the dotfiles directory so lua files
    # remain editable without rebuilding. Home Manager owns neovim itself;
    # the lua config stays outside the Nix store.
    home.activation.linkNeovimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ln -sfn "${config.home.homeDirectory}/Projects/nixos/dotfiles/neovim/.config/nvim" \
            "${config.xdg.configHome}/nvim"
    '';

    # Tools neovim needs at runtime
    home.packages = with pkgs; [
        ripgrep  # live grep (snacks, telescope)
        fd       # file finder
    ];
    # gcc and gnumake (treesitter) are already provided by dev-tools.nix
}
