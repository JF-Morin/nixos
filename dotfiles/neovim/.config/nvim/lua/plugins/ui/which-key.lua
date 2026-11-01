return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    win = {
      width = 0.4,
      height = { min = 4, max = 25 },
      col = math.huge,
      row = 0,
      border = "rounded",
    },
    layout = {
      width = { min = 20 },
      spacing = 3,
    },
    spec = {
      { "<leader>f",  group = "Find" },
      { "<leader>g",  group = "Git" },
      { "<leader>s",  group = "Search" },
      { "<leader>c",  group = "Code" },
      { "<leader>u",  group = "UI" },
      { "<leader>b",  group = "Buffer" },
      { "<leader>w",  group = "Window" },
      { "<leader>d",  group = "Diagnostics" },
      { "<leader>t",  group = "Terminal" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps",
    },
  },
}
