local status_ok, _toggle_term = pcall(require, "toggleterm")
if not status_ok then return end

_toggle_term.setup{
  direction = "horizontal",
  open_mapping = false, -- mapped below
}

local terminals = {}
local M = {}

function M.toggle_terminal()
  local Terminal = require('toggleterm.terminal').Terminal
  local current_tab = vim.api.nvim_get_current_tabpage()
  local current_term = terminals[current_tab]

  if not current_term then
    -- steal an existing terminal from another tab rather than creating a new one
    for other_tab, term in pairs(terminals) do
      if other_tab ~= current_tab then
        if term:is_open() then
          term:toggle()
        end
        terminals[current_tab] = term
        terminals[other_tab] = nil
        current_term = term
        break
      end
    end
  end

  if not current_term then
    terminals[current_tab] = Terminal:new { go_back = false }
    current_term = terminals[current_tab]
  end

  -- toggleterm would change current tab to the toggled terminal's tab
  -- if there is any opened terminal in another tab, so need to switch back to
  -- the original tab before toggling
  vim.api.nvim_set_current_tabpage(current_tab)
  current_term:toggle()
end

-- Keymaps
vim.keymap.set({ 'n', 't' }, '<c-\\>', function() M.toggle_terminal() end, { desc = "Toggle terminal" })

-- easy navigation inside a terminal buffer
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = 'term://*',
  callback = function()
    local opts = { buffer = 0 }
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set('t', '<C-n>', [[<C-\><C-n><C-w>]], opts)
  end,
})

return M
