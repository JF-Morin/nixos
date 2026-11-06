return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    -- master branch is archived and incompatible with Neovim 0.12
    branch = "main",
    init = function()
        -- Nix-compiled parsers take precedence over any lazily compiled ones.
        vim.opt.runtimepath:prepend(vim.fn.stdpath('data') .. '/nix-ts-parsers')
    end,
    config = function()
        require('nvim-treesitter').setup()
    end
}
