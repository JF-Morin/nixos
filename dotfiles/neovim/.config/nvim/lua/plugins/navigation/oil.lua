return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {
        default_file_explorer = false, -- snacks handles sidebar exploration
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        view_options = {
            show_hidden = true,
        },
        float = {
            padding = 2,
            max_width = 80,
            max_height = 30,
            border = "rounded",
        },
        keymaps = {
            ["<CR>"] = "actions.select",
            ["<BS>"] = "actions.parent",
            ["_"] = "actions.open_cwd",
            ["q"] = "actions.close",
            ["gs"] = "actions.change_sort",
            ["g."] = "actions.toggle_hidden",
            ["gx"] = "actions.open_external",
            ["<C-p>"] = "actions.preview",
            ["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open in vertical split" },
            ["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open in horizontal split" },
        },
        use_default_keymaps = false,
    },
    keys = {
        { "<leader>o", function() require("oil").open_float() end, desc = "Open parent directory" },
    },
}
