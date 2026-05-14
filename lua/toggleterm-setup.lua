local status_ok, _toggle_term = pcall(require, "toggleterm")
if not status_ok then return end

_toggle_term.setup{
  direction = "horizontal",
  open_mapping = false, -- use the one in keymaps.lua
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

return M
