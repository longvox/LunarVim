local M = {}
local Log = require "core.log"

local generic_opts_any = { noremap = true, silent = true }

local generic_opts = {
  insert_mode = generic_opts_any,
  normal_mode = generic_opts_any,
  visual_mode = generic_opts_any,
  visual_block_mode = generic_opts_any,
  term_mode = { silent = true },
}

local mode_adapters = {
  insert_mode = "i",
  normal_mode = "n",
  term_mode = "t",
  visual_mode = "v",
  visual_block_mode = "x",
}

-- Append key mappings to lunarvim's defaults for a given mode
-- @param keymaps The table of key mappings containing a list per mode (normal_mode, insert_mode, ..)
function M.append_to_defaults(keymaps)
  for mode, mappings in pairs(keymaps) do
    for k, v in ipairs(mappings) do
      lvim.keys[mode][k] = v
    end
  end
end

-- Set key mappings individually
-- @param mode The keymap mode, can be one of the keys of mode_adapters
-- @param key The key of keymap
-- @param val Can be form as a mapping or tuple of mapping and user defined opt
function M.set_keymaps(mode, key, val)
  local opt = generic_opts[mode] and generic_opts[mode] or generic_opts_any
  if type(val) == "table" then
    opt = val[2]
    val = val[1]
  end
  vim.api.nvim_set_keymap(mode, key, val, opt)
end

-- Load key mappings for a given mode
-- @param mode The keymap mode, can be one of the keys of mode_adapters
-- @param keymaps The list of key mappings
function M.load_mode(mode, keymaps)
  mode = mode_adapters[mode] and mode_adapters[mode] or mode
  for k, v in pairs(keymaps) do
    M.set_keymaps(mode, k, v)
  end
end

-- Load key mappings for all provided modes
-- @param keymaps A list of key mappings for each mode
function M.load(keymaps)
  for mode, mapping in pairs(keymaps) do
    M.load_mode(mode, mapping)
  end
end

function M.config()
  lvim.keys = {
    ---@usage change or add keymappings for insert mode
    insert_mode = {
      -- 'jk' for quitting insert mode
      ["jk"] = "<ESC>",

      -- 'kj' for quitting insert mode
      ["kj"] = "<ESC>",

      -- 'jj' for quitting insert mode
      ["jj"] = "<ESC>",

      -- Move current line / block with Alt-j/k ala vscode.
      ["∆"] = "<Esc>:m .+1<CR>==gi",
      ["˚"] = "<Esc>:m .-2<CR>==gi",

      -- Set time
      ["<F3>"] = "<C-R>=strftime(\"%Y-%m-%d %a %I:%M %p\")<CR>",

      -- Uppercase current word
      ["<C-U>"] = "<esc>viwUA",

      -- navigation
      ["<A-Up>"] = "<C-\\><C-N><C-w>k",
      ["<A-Down>"] = "<C-\\><C-N><C-w>j",
      ["<A-Left>"] = "<C-\\><C-N><C-w>h",
      ["<A-Right>"] = "<C-\\><C-N><C-w>l",

      -- navigate tab completion with <c-j> and <c-k>
      -- runs conditionally
      ["<C-j>"] = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } },
      ["<C-k>"] = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } },
    },

    ---@usage change or add keymappings for normal mode
    normal_mode = {
      ["<space>"] = "<nop>",
      --- Hardcore
      ["<up>"] = ":echoe \"please use \'k\' key\"<CR>",
      ["<down>"] =  ":echoe \"please use \'j\' key\"<CR>",
      ["<left>"] = ":echoe \"please use \'h\' key\"<CR>",
      ["<right>"] = ":echoe \"please use \'l\' key\"<CR>",

      -- Map hjkl
      ["j"] = "gj",
      ["k"] = "gk",
      ["H"] = "h",
      ["L"] = "l",
      ["l"] = "w",
      ["h"] = "b",

      -- Map to no replace buffer copy
      ["d"] = "\"_d",
      ["D"] = "\"_D",
      ["c"] = "\"_c",
      ["C"] = "\"_C",

      -- Add simple hightlight removal
      ["<ESC><ESC>"] = ":nohlsearch<CR>",

      -- keep search results at the center of screen
      ["n"] = "nzz",
      ["N"] = "Nzz",
      ["*"] = "*zz",
      ["#"] = "#zz",
      ["g*"] = "g*zz",
      ["g#"] = "g#zz",
      ["gd"] = "gdzz",
      ["[["] = "[[zz",
      ["]]"] = "]]zz",

      -- Don't use recording now
      ["q"] = "<Nop>",

      -- Set time
      ["<F3>"] = "i<C-R>=strftime(\"%Y-%m-%d %a %I:%M %p\")<CR><Esc>",

      -- Move to beginning/end of line
      ["b"] = "^",
      ["e"] = "$",

      -- $/^ doesn't do anything
      ["$"] = "<nop>",
      ["^"] = "<nop>",

      -- Quickly add empty lines
      ["<C-o>"] =  ":<c-u>put =repeat(nr2char(10), v:count1)<cr>",

      -- Better window movement
      ["<C-h>"] = "<C-w>h",
      ["<C-j>"] = "<C-w>j",
      ["<C-k>"] = "<C-w>k",
      ["<C-l>"] = "<C-w>l",

      -- Resize with arrows
      ["<C-Up>"] = ":resize -2<CR>",
      ["<C-Down>"] = ":resize +2<CR>",
      ["<C-Left>"] = ":vertical resize -2<CR>",
      ["<C-Right>"] = ":vertical resize +2<CR>",

      -- Tab switch buffer
      ["¬"] = ":BufferNext<CR>",
      ["˙"] = ":BufferPrevious<CR>",

      -- switch tab
      ["<S-¬>"] = ":tabnext<CR>",
      ["<S-˙>"] = ":tabprevious<CR>",

      -- Move current line / block with Alt-j/k a la vscode.
      ["∆"] = ":m .+1<CR>==",
      ["˚"] = ":m .-2<CR>==",

      -- QuickFix
      ["]q"] = ":cnext<CR>",
      ["[q"] = ":cprev<CR>",
      ["<C-q>"] = ":call QuickFixToggle()<CR>",
    },

    ---@usage change or add keymappings for terminal mode
    term_mode = {
      -- Terminal window navigation
      ["<C-h>"] = "<C-\\><C-N><C-w>h",
      ["<C-j>"] = "<C-\\><C-N><C-w>j",
      ["<C-k>"] = "<C-\\><C-N><C-w>k",
      ["<C-l>"] = "<C-\\><C-N><C-w>l",

      -- Replace
      ["®"] = ":%s//gI<Left><Left><Left>",
    },

    ---@usage change or add keymappings for visual mode
    visual_mode = {
      -- Better indenting
      ["<"] = "<gv",
      [">"] = ">gv",

      -- ["p"] = '"0p',
      -- ["P"] = '"0P',

      -- map hjkl
      ["j"] = "gj",
      ["k"] = "gk",
      ["H"] = "h",
      ["L"] = "l",
      ["l"] = "w",
      ["h"] = "b",

      -- map to no replace buffer copy
      ["d"] = "\"_d",
      ["D"] = "\"_D",
      ["c"] = "\"_c",
      ["C"] = "\"_C",

      -- Select all text
      ["a"] = "ggVG",
    },

    ---@usage change or add keymappings for visual block mode
    visual_block_mode = {
      -- Move current line / block with Alt-j/k a la vscode.
      ["∆"] = ":m '>+1<cr>gv=gv",
      ["˚"] = ":m '<-2<cr>gv=gv",
    },
  }

  if vim.fn.has "mac" == 1 then
    lvim.keys.normal_mode["<A-Up>"] = lvim.keys.normal_mode["<C-Up>"]
    lvim.keys.normal_mode["<A-Down>"] = lvim.keys.normal_mode["<C-Down>"]
    lvim.keys.normal_mode["<A-Left>"] = lvim.keys.normal_mode["<C-Left>"]
    lvim.keys.normal_mode["<A-Right>"] = lvim.keys.normal_mode["<C-Right>"]
    if Log:get_default() then
      Log:get_default().info "Activated mac keymappings"
    end
  end
end

function M.print(mode)
  print "List of LunarVim's default keymappings (not including which-key)"
  if mode then
    print(vim.inspect(lvim.keys[mode]))
  else
    print(vim.inspect(lvim.keys))
  end
end

function M.setup()
  vim.g.mapleader = (lvim.leader == "space" and " ") or lvim.leader
  M.load(lvim.keys)
end

return M
