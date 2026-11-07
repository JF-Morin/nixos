vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Leave a terminal (e.g. the Claude pane) and jump back to the previous window
vim.keymap.set("t", "<C-b>", "<C-\\><C-n><C-w>p", { desc = "Back to previous window" })
