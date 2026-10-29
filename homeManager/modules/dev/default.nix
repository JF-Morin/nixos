{ config ,pkgs, ... }:

{
    imports = [
        ./gh.nix
        ./git.nix
        ./dev-tools.nix
        ./lsp.nix
        ./formatters.nix
        ./neovim.nix
    ];
}
