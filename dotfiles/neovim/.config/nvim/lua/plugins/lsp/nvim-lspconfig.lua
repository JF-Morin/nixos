return {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- For lsp to know `vim` global
        {
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {
                library = {
                    { path = "${3rd}/luv/library", words = {"vim%.uv"} },
                },
            },
        },
    },
    config = function()
        local lspconfig = require("lspconfig")
        lspconfig.bashls.setup({})
        lspconfig.clangd.setup({})
        lspconfig.cssls.setup({})
        lspconfig.dockerls.setup({})
        lspconfig.docker_compose_language_service.setup({})
        --lspconfig.eslint.setup({})
        lspconfig.gopls.setup({})
        lspconfig.html.setup({})
        lspconfig.htmx.setup({ filetypes = { "html" } })
        lspconfig.jsonls.setup({})
        lspconfig.ts_ls.setup({})
        lspconfig.lua_ls.setup({})
        lspconfig.marksman.setup({})
        lspconfig.nixd.setup({})
        lspconfig.pyright.setup({})
        lspconfig.rust_analyzer.setup({})
        lspconfig.sqlls.setup({})
        lspconfig.svelte.setup({})
        lspconfig.tailwindcss.setup({})
        lspconfig.taplo.setup({})
        lspconfig.lemminx.setup({})
        lspconfig.zls.setup({})
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
    end,
}
