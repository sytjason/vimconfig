-- Core editor keymaps only.
-- Plugin keymaps live in the corresponding *-setup.lua file.

local function map(mode, lhs, rhs)
  vim.keymap.set(mode, lhs, rhs, {})
end

local function toggleLinenum()
  if vim.o.nu and vim.o.rnu then
    vim.o.nu = false
    vim.o.rnu = false
  else
    vim.o.nu = true
    vim.o.rnu = true
  end
end

-- Navigations between panes
map('n', '<C-j>', '<C-W>j')
map('n', '<C-k>', '<C-W>k')
map('n', '<C-h>', '<C-W>h')
map('n', '<C-l>', '<C-W>l')

-- resize windows
map('n', '-', '<C-W>-')
map('n', '_', '<C-W>+')
map('n', '=', '<C-W><')
map('n', '+', '<C-W>>')

-- Move text up and down
map('v', 'J', ":move '>+1<CR>gv-gv")
map('v', 'K', ":move '<-2<CR>gv-gv")
map('v', '<A-j>', ":move '>+1<CR>gv-gv")
map('v', '<A-k>', ":move '<-2<CR>gv-gv")

-- toggle line num
map('n', '<leader>nu', toggleLinenum)
