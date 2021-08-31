local M = {}
local u = require "utils"
local null_ls_handler = require "lsp.null-ls"
local indent = "  "

M.banner = {
  " ",
  indent .. "⠀⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ⠀⠀     ⠀⠀⠀   ⠀⠀ ⣺⡿⠀⠀⠀⠀⠀⠀⠀ ⠀⠀⠀",
  indent .. "⠀⣿⠇⠀⠀⠀⠀⠀⣤⡄⠀⠀⢠⣤⡄⠀.⣠⣤⣤⣤⡀⠀⠀⢀⣤⣤⣤⣤⡄⠀⠀⠀⣤⣄⣤⣤⣤⠀⠀ ⣿⣯  ⣿⡟⠀   ⣤⣤⠀⠀⠀⠀⣠⣤⣤⣤⣄⣤⣤",
  indent .. "⢠⣿⠀⠀⠀⠀⠀⠀⣿⠃⠀⠀⣸⣿⠁⠀⣿⣿⠉⠀⠈⣿⡇⠀⠀⠛⠋⠀⠀⢹⣿⠀⠀⠀⣿⠏⠀⠸⠿⠃⠀⣿⣿⠀⣰⡟⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⣿⡟⢸⣿⡇⢀⣿",
  indent .. "⣸⡇⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⣿⡟⠀⢠⣿⡇⠀⠀⢰⣿⡇⠀⣰⣾⠟⠛⠛⣻⡇⠀⠀⢸⡿⠀⠀⠀⠀⠀⠀⢻⣿⢰⣿⠀⠀⠀⠀⠀⠀⣾⡇⠀⠀⠀⢸⣿⠇⢸⣿⠀⢸⡏",
  indent .. "⣿⣧⣤⣤⣤⡄⠀⠘⣿⣤⣤⡤⣿⠇⠀⢸⣿⠁⠀⠀⣼⣿⠀⠀⢿⣿⣤⣤⠔⣿⠃⠀⠀⣾⡇⠀⠀⠀⠀⠀⠀⢸⣿⣿⠋⠀⠀⠀⢠⣤⣤⣿⣥⣤⡄⠀⣼⣿⠀⣸⡏⠀⣿⠃",
  indent .. "⠉⠉⠉⠉⠉⠁⠀⠀⠈⠉⠉⠀⠉⠀⠀⠈⠉⠀⠀⠀⠉⠉⠀⠀⠀⠉⠉⠁⠈⠉⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠁⠀⠉⠁⠀⠉⠁⠀⠉⠀",
  "",
}

local function str_list(list)
  return "[ " .. table.concat(list, ", ") .. " ]"
end

local function get_formatter_suggestion_msg(ft)
  local supported_formatters = u.get_supported_formatters_by_filetype(ft)
  return {
    indent .. "───────────────────────────────────────────────────────────────────", "",
    indent .. " HINT ", "",
    indent .. "* List of supported formatters: " .. str_list(supported_formatters),
    indent .. "* Configured formatter needs to be installed and executable.",
    indent .. "* Enable installed formatter(s) with following config in ~/.config/lvim/config.lua", "",
    indent .. "  lvim.lang." .. tostring(ft) .. [[.formatting = { { exe = ']] .. table.concat(supported_formatters, "│") .. [[' } }]],
    "",
  }
end

local function get_linter_suggestion_msg(ft)
  local supported_linters = u.get_supported_linters_by_filetype(ft)
  return {
    indent .. "───────────────────────────────────────────────────────────────────", "",
    indent .. " HINT ", "",
    indent .. "* List of supported linters: " .. str_list(supported_linters),
    indent .. "* Configured linter needs to be installed and executable.",
    indent .. "* Enable installed linter(s) with following config in ~/.config/lvim/config.lua", "",
    indent .. "  lvim.lang." .. tostring(ft) .. [[.linters = { { exe = ']] .. table.concat(supported_linters, "│") .. [[' } }]],
    "",
  }
end

---creates an average size popup
---@param buf_lines a list of lines to print
---@param callback could be used to set syntax highlighting rules for example
---@return bufnr buffer number of the created buffer
---@return win_id window ID of the created popup
function M.create_simple_popup(buf_lines, callback)
  -- runtime/lua/vim/lsp/util.lua
  local bufnr = vim.api.nvim_create_buf(false, true)
  local height_percentage = 0.9
  local width_percentage = 0.8
  local row_start_percentage = (1 - height_percentage) / 2
  local col_start_percentage = (1 - width_percentage) / 2
  local opts = {}
  opts.relative = "editor"
  opts.height = math.min(math.ceil(vim.o.lines * height_percentage), #buf_lines)
  opts.row = math.ceil(vim.o.lines * row_start_percentage)
  opts.col = math.floor(vim.o.columns * col_start_percentage)
  opts.width = math.floor(vim.o.columns * width_percentage)
  opts.style = "minimal"
  opts.border = "rounded"
  --[[
  opts.border = {
    lvim.builtin.telescope.defaults.borderchars[5], -- "┌",
    lvim.builtin.telescope.defaults.borderchars[3], -- "-",
    lvim.builtin.telescope.defaults.borderchars[6], -- "┐",
    lvim.builtin.telescope.defaults.borderchars[2], -- "|",
    lvim.builtin.telescope.defaults.borderchars[7], -- "┘",
    lvim.builtin.telescope.defaults.borderchars[3], -- "-",
    lvim.builtin.telescope.defaults.borderchars[8], -- "└",
    lvim.builtin.telescope.defaults.borderchars[4], -- "|",
  }
  --]]

  local win_id = vim.api.nvim_open_win(bufnr, true, opts)

  vim.api.nvim_win_set_buf(win_id, bufnr)
  -- this needs to be window option!
  vim.api.nvim_win_set_option(win_id, "number", false)
  vim.cmd "setlocal nocursorcolumn"
  vim.cmd "setlocal wrap"
  -- set buffer options
  vim.api.nvim_buf_set_option(bufnr, "filetype", "lspinfo")
  vim.lsp.util.close_preview_autocmd({ "BufHidden", "BufLeave" }, win_id)
  buf_lines = vim.lsp.util._trim(buf_lines, {})
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, buf_lines)
  vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
  if type(callback) == "function" then
    callback()
  end
  return bufnr, win_id
end

local function tbl_set_highlight(terms, highlight_group)
  if type(terms) ~= "table" then
    return
  end

  for _, v in pairs(terms) do
    vim.cmd('let m=matchadd("' .. highlight_group .. '", "' .. v .. '")')
  end
end

function M.toggle_popup(ft)
  local client = u.get_active_client_by_ft(ft)
  local is_client_active = false
  local client_enabled_caps = {}
  local client_name = ""
  local client_id = 0
  local document_formatting = false
  local missing_linters = {}
  local missing_formatters = {}
  local num_caps = 0
  local null_ls_providers = null_ls_handler.get_registered_providers_by_filetype(ft)
  if client ~= nil then
    is_client_active = not client.is_stopped()
    client_enabled_caps = require("lsp").get_ls_capabilities(client.id)
    num_caps = vim.tbl_count(client_enabled_caps)
    client_name = client.name
    client_id = client.id
    document_formatting = client.resolved_capabilities.document_formatting
  end
  if lvim.lang[ft] ~= nil then
    missing_linters = lvim.lang[ft].linters._failed_requests or {}
    missing_formatters = lvim.lang[ft].formatters._failed_requests or {}
  end

  local buf_lines = {}
  vim.list_extend(buf_lines, M.banner)

  local header = {
    indent .. "Detected filetype:     " .. tostring(ft),
    indent .. "Treesitter active:     " .. tostring(next(vim.treesitter.highlighter.active) ~= nil),
    "",
  }
  vim.list_extend(buf_lines, header)

  local lsp_info = {
    indent .. "Language Server Protocol (LSP) info",
    indent .. "* Associated server:   " .. client_name,
    indent .. "* Active:              " .. tostring(is_client_active) .. " (id: " .. tostring(client_id) .. ")",
    indent .. "* Supports formatting: " .. tostring(document_formatting),
    indent .. "* Capabilities list:   " .. table.concat(vim.list_slice(client_enabled_caps, 1, num_caps / 2), ", "),
    indent .. indent .. indent .. table.concat(vim.list_slice(client_enabled_caps, ((num_caps / 2) + 1)), ", "),
    "",
  }
  vim.list_extend(buf_lines, lsp_info)

  local null_ls_info = {
    indent .. "Formatters and linters",
    indent .. "* Configured providers: " .. table.concat(null_ls_providers, "  , ") .. "  ",
  }
  vim.list_extend(buf_lines, null_ls_info)

  local missing_formatters_status
  if vim.tbl_count(missing_formatters) > 0 then
    missing_formatters_status = {
      indent .. "* Missing formatters:   " .. table.concat(missing_formatters, "  , ") .. "  ",
    }
    vim.list_extend(buf_lines, missing_formatters_status)
  end

  local missing_linters_status
  if vim.tbl_count(missing_linters) > 0 then
    missing_linters_status = {
      indent .. "* Missing linters:      " .. table.concat(missing_linters, "  , ") .. "  ",
    }
    vim.list_extend(buf_lines, missing_linters_status)
  end

  vim.list_extend(buf_lines, { "" })

  vim.list_extend(buf_lines, get_formatter_suggestion_msg(ft))

  vim.list_extend(buf_lines, get_linter_suggestion_msg(ft))

  local function set_syntax_hl()
    vim.cmd [[highlight LvimInfoIdentifier gui=bold]]
    vim.cmd [[highlight link LvimInfoHeader Type]]
    vim.cmd [[let m=matchadd("DashboardHeader", "Language Server Protocol (LSP) info")]]
    vim.cmd [[let m=matchadd("DashboardHeader", "Formatters and linters")]]
    vim.cmd('let m=matchadd("LvimInfoIdentifier", " ' .. ft .. '$")')
    vim.cmd 'let m=matchadd("string", "true")'
    vim.cmd 'let m=matchadd("error", "false")'
    tbl_set_highlight(null_ls_providers, "LvimInfoIdentifier")
    tbl_set_highlight(missing_formatters, "LvimInfoIdentifier")
    tbl_set_highlight(missing_linters, "LvimInfoIdentifier")
    -- tbl_set_highlight(u.get_supported_formatters_by_filetype(ft), "LvimInfoIdentifier")
    -- tbl_set_highlight(u.get_supported_linters_by_filetype(ft), "LvimInfoIdentifier")
    vim.cmd('let m=matchadd("LvimInfoIdentifier", "' .. client_name .. '")')
  end

  return M.create_simple_popup(buf_lines, set_syntax_hl)
end
return M
