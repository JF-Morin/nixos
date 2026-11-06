return {
    "neovim/nvim-lspconfig",
    dependencies = {
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
        vim.lsp.config('htmx', { filetypes = { 'html' } })

        vim.lsp.enable({
            'bashls',
            'clangd',
            'cssls',
            'dockerls',
            'docker_compose_language_service',
            'gopls',
            'html',
            'htmx',
            'jsonls',
            'ts_ls',
            'lua_ls',
            'marksman',
            'nixd',
            'pyright',
            'rust_analyzer',
            'sqlls',
            'svelte',
            'tailwindcss',
            'taplo',
            'lemminx',
            'zls',
        })

        vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
    end,
}
