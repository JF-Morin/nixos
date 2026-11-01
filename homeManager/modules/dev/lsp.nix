{ pkgs, ... }:

{
    home.packages = with pkgs; [
        bash-language-server                      # Bash
        vscode-langservers-extracted              # HTML, CSS, JSON, Docker Compose (replaces vscode-json-languageserver)
        ccls                                      # C / C++
        docker-language-server                    # Dockerfile
        emmet-language-server                     # HTML / CSS (Emmet snippets)
        gopls                                     # Go
        htmx-lsp                                  # HTMX attributes
        lemminx                                   # XML
        lua-language-server                       # Lua
        marksman                                  # Markdown
        nil                                       # Nix (basic)
        nixd                                      # Nix (full, flake-aware)
        pyright                                   # Python
        roslyn-ls                                 # C#
        sqls                                      # SQL
        svelte-language-server                    # Svelte
        tailwindcss-language-server               # Tailwind CSS
        taplo                                     # TOML
        typescript-language-server                # TypeScript / JavaScript
        vscode-extensions.rust-lang.rust-analyzer # Rust
        yaml-language-server                      # YAML
        zls                                       # Zig
    ];
}
