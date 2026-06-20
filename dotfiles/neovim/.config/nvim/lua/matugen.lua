 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#21252b',
    base01 = '#282c34',
    base02 = '#313640',
    base03 = '#666e7e',
    base04 = '#78c4ce',
    base05 = '#c9ccd3',
    base06 = '#c9ccd3',
    base07 = '#c9ccd3',
    base08 = '#e27881',
    base09 = '#98c379',
    base0A = '#eac786',
    base0B = '#62bac6',
    base0C = '#b9e996',
    base0D = '#96dfe9',
    base0E = '#eccd92',
    base0F = '#96111c',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#c9ccd3',          bg = '#21252b' })
  hi('TelescopeBorder',         { fg = '#666e7e',             bg = '#21252b' })
  hi('TelescopePromptNormal',   { fg = '#c9ccd3',          bg = '#21252b' })
  hi('TelescopePromptBorder',   { fg = '#666e7e',             bg = '#21252b' })
  hi('TelescopePromptPrefix',   { fg = '#62bac6',             bg = '#21252b' })
  hi('TelescopePromptCounter',  { fg = '#78c4ce',  bg = '#21252b' })
  hi('TelescopePromptTitle',    { fg = '#21252b',             bg = '#62bac6' })
  hi('TelescopePreviewTitle',   { fg = '#21252b',             bg = '#eac786' })
  hi('TelescopeResultsTitle',   { fg = '#21252b',             bg = '#98c379' })
  hi('TelescopeSelection',      { fg = '#c9ccd3',          bg = '#313640' })
  hi('TelescopeSelectionCaret', { fg = '#62bac6',             bg = '#313640' })
  hi('TelescopeMatching',       { fg = '#62bac6',             bold = true })
end

 -- Register a signal handler for SIGUSR1 (matugen updates)
 local signal = vim.uv.new_signal()
 signal:start(
   'sigusr1',
   vim.schedule_wrap(function()
     package.loaded['matugen'] = nil
     require('matugen').setup()
   end)
 )

 return M
