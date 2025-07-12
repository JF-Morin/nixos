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
        --local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local capabilities = {}
        local lspconfig = require("lspconfig")
        lspconfig.bashls.setup({})
        lspconfig.clangd.setup({})
        lspconfig.omnisharp.setup({})
        lspconfig.cssls.setup({})
        lspconfig.dockerls.setup({})
        lspconfig.docker_compose_language_service.setup({})
        --lspconfig.eslint.setup({})
        lspconfig.gopls.setup({})
        lspconfig.html.setup({})
        lspconfig.htmx.setup({})
        lspconfig.jsonls.setup({})
        lspconfig.ts_ls.setup({})
        lspconfig.lua_ls.setup({})
        lspconfig.marksman.setup({})
        --lspconfig.nixfmt.setup({})
        --lspconfig.pyright.setup({})
        --lspconfig.nil.setup({})
        lspconfig.nixd.setup({})
        lspconfig.rust_analyzer.setup({})
        lspconfig.sqlls.setup({})
        lspconfig.svelte.setup({})
        lspconfig.tailwindcss.setup({})
        lspconfig.lemminx.setup({})
        lspconfig.hydra_lsp.setup({})
        lspconfig.zls.setup({})
        vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
    end,
}
