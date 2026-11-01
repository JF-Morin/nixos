 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#22262c',
    base01 = '#21252b',
    base02 = '#282c34',
    base03 = '#666e7e',
    base04 = '#78c4ce',
    base05 = '#c9ccd3',
    base06 = '#c9ccd3',
    base07 = '#c9ccd3',
    base08 = '#e27881',
    base09 = '#98c379',
    base0A = '#eac786',
    base0B = '#62bac6',
    base0C = '#16565f',
    base0D = '#3f6920',
    base0E = '#b0770e',
    base0F = '#daeff1',
  })
end

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
