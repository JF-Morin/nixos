return {
    "nvimtools/none-ls.nvim",
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.csharpier,    -- C#
                null_ls.builtins.formatting.nixfmt,       -- Nix
                null_ls.builtins.formatting.prettierd,    -- JS/TS/HTML/CSS/Markdown/YAML/JSON
                null_ls.builtins.formatting.ruff,         -- Python
                null_ls.builtins.formatting.shfmt,        -- Shell
                null_ls.builtins.formatting.stylua,       -- Lua
                null_ls.builtins.formatting.taplo,        -- TOML
            },
        })
        vim.keymap.set("n", "<leader>=f", vim.lsp.buf.format, {})
    end,
}
