vim.api.nvim_command "hi clear"
if vim.fn.exists "syntax_on" then
  vim.api.nvim_command "syntax reset"
end
vim.o.background = "dark"
vim.o.termguicolors = true
vim.g.colors_name = "darkspace"

local util = require "gui.util"
Config = require "gui.config"
C = require "gui.palette"

local async
async = vim.loop.new_async(vim.schedule_wrap(function()
  local skeletons = {}
  for _, skeleton in ipairs(skeletons) do
    util.initialise(skeleton)
  end

  async:close()
end))

local highlights = require "gui.highlights"
local Treesitter = require "gui.Treesitter"
local markdown = require "gui.markdown"
local Whichkey = require "gui.Whichkey"
local Git = require "gui.Git"
local LSP = require "gui.LSP"

local skeletons = {
  highlights,
  Treesitter,
  markdown,
  Whichkey,
  Git,
  LSP,
}

for _, skeleton in ipairs(skeletons) do
  util.initialise(skeleton)
end

async:send()
