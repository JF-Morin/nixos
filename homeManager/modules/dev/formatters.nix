{ pkgs, ... }:

{
    home.packages = with pkgs; [
        csharpier   # C#
        nixfmt      # Nix
        prettierd   # JS / TS / HTML / CSS / Markdown / YAML / JSON
        ruff        # Python (linter + formatter)
        shfmt       # Shell / Bash
        stylua      # Lua
        taplo       # TOML
    ];
}
