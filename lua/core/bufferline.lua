local M = {}

M.config = function()
  lvim.builtin.bufferline = {
    active = true,
    keymap = {
      normal_mode = {
        ["¬"] = ":BufferNext<CR>",
        ["˙"] = ":BufferPrevious<CR>",
      },
    },
  }
end

M.setup = function()
  local keymap = require "keymappings"
  keymap.append_to_defaults(lvim.builtin.bufferline.keymap)
end

return M
