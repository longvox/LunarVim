local M = {}

M.defaults = {
  [[
  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      copen
    else
      cclose
    endif
  endfunction
  ]],
  -- :LvimInfo
  [[command! LvimInfo lua require('core.info').toggle_popup(vim.bo.filetype)]],
  [[
    let g:user_emmet_settings = { 'php': {'extends': 'html', 'filters' : 'c'}, 'xml': {'extends': 'html'}, 'haml': {'extends': 'html' }}
  ]],
  [[let g:user_emmet_leader_key='<leader>,']],
  [[let g:user_emmet_mode='nv']],
  [[set mps+=<:>]]
}

M.load = function(commands)
  for _, command in ipairs(commands) do
    vim.cmd(command)
  end
end

return M
