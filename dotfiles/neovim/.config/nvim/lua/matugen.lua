 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#2e3440',
    base01 = '#3b4252',
    base02 = '#444c5e',
    base03 = '#6f7d98',
    base04 = '#e5e9f0',
    base05 = '#eceff4',
    base06 = '#eceff4',
    base07 = '#eceff4',
    base08 = '#bf616a',
    base09 = '#ebcb8b',
    base0A = '#a3be8c',
    base0B = '#b48ead',
    base0C = '#ecce92',
    base0D = '#e996d9',
    base0E = '#bce996',
    base0F = '#d7f4be',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- telescope.nvim
  hi('TelescopeNormal',         { fg = '#eceff4',          bg = '#2e3440' })
  hi('TelescopeBorder',         { fg = '#6f7d98',             bg = '#2e3440' })
  hi('TelescopePromptNormal',   { fg = '#eceff4',          bg = '#2e3440' })
  hi('TelescopePromptBorder',   { fg = '#6f7d98',             bg = '#2e3440' })
  hi('TelescopePromptPrefix',   { fg = '#b48ead',             bg = '#2e3440' })
  hi('TelescopePromptCounter',  { fg = '#e5e9f0',  bg = '#2e3440' })
  hi('TelescopePromptTitle',    { fg = '#2e3440',             bg = '#b48ead' })
  hi('TelescopePreviewTitle',   { fg = '#2e3440',             bg = '#a3be8c' })
  hi('TelescopeResultsTitle',   { fg = '#2e3440',             bg = '#ebcb8b' })
  hi('TelescopeSelection',      { fg = '#eceff4',          bg = '#444c5e' })
  hi('TelescopeSelectionCaret', { fg = '#b48ead',             bg = '#444c5e' })
  hi('TelescopeMatching',       { fg = '#b48ead',             bold = true })

  -- mini.pick
  hi('MiniPickNormal',         { fg = '#eceff4',          bg = '#2e3440' })
  hi('MiniPickBorder',         { fg = '#6f7d98',             bg = '#2e3440' })
  hi('MiniPickPrompt',   { fg = '#eceff4',          bg = '#2e3440' })
  hi('MiniPickPromptPrefix',   { fg = '#b48ead',             bg = '#2e3440' })
  hi('MiniPickBorderText',    { fg = '#2e3440',             bg = '#b48ead' })
  hi('MiniPickMatchCurrent',      { fg = '#eceff4',          bg = '#444c5e' })
  hi('MiniPickPromptCaret', { fg = '#b48ead',             bg = '#444c5e' })
  hi('MiniPickMatchRanges',       { fg = '#b48ead',             bold = true })
end

-- Register a signal handler for SIGUSR1 (matugen updates).
-- The handler re-requires this module, which re-runs the code below, so the
-- previous handle is stopped first; otherwise handlers double on every signal.
if _G.__matugen_signal then
  _G.__matugen_signal:stop()
  _G.__matugen_signal:close()
end

local signal = vim.uv.new_signal()
_G.__matugen_signal = signal
signal:start(
  'sigusr1',
  vim.schedule_wrap(function()
    package.loaded['matugen'] = nil
    require('matugen').setup()
  end)
)

return M
