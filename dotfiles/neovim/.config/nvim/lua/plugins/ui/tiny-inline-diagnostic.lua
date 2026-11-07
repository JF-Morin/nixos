return {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {
        preset = "modern",
        options = {
            show_source = { enabled = true },
            multilines = { enabled = true },
            -- Show diagnostics for the whole line, not only under the cursor
            show_all_diags_on_cursorline = true,
        },
    },
    config = function(_, opts)
        require("tiny-inline-diagnostic").setup(opts)
        -- Disable Neovim's built-in virtual text so diagnostics aren't shown twice
        vim.diagnostic.config({ virtual_text = false })
    end,
}
