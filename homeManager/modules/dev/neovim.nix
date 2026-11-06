{ config, pkgs, lib, ... }:

let
  g = pkgs.vimPlugins.nvim-treesitter.grammarPlugins;

  # Languages beyond the 7 Neovim ships built-in
  # (c, lua, markdown, markdown_inline, query, vim, vimdoc are already bundled).
  # luadoc / luap / printf are injected by the Lua parser for doc-comments and
  # pattern/format strings — they must be present or the highlighter crashes.
  extraParsers = [
    "bash" "c_sharp" "cpp" "css" "csv" "dart" "dockerfile"
    "go" "html" "http" "javascript" "json"
    "luadoc" "luap" "nix" "printf" "python"
    "regex" "rust" "scss" "sql" "svelte"
    "tsx" "typst" "typescript" "vue" "xml" "yaml" "zig"
  ];
in
{
  home.packages = with pkgs; [
    neovim
    ripgrep  # live grep (snacks, telescope)
    fd       # file finder
  ];

  # Nix-compiled parsers, always ABI-compatible with the installed Neovim.
  # treesitter.lua prepends stdpath('data')/nix-ts-parsers to runtimepath so
  # Neovim finds these .so files as parser/<lang>.so.
  xdg.dataFile = builtins.listToAttrs (map (lang: {
    name  = "nvim/nix-ts-parsers/parser/${lang}.so";
    value.source = "${g.${lang}}/parser/${lang}.so";
  }) extraParsers);

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
