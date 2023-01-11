local function map (mode, lhs, rhs)
  vim.keymap.set(mode, lhs, rhs, {})
end

-- Navigations between panes
map('n', '<C-j>', '<C-W>j')
map('n', '<C-k>', '<C-W>k')
map('n', '<C-h>', '<C-W>h')
map('n', '<C-l>', '<C-W>l')

-- Move text up and down
map('v', "J", ":move '>+1<CR>gv-gv")
map('v', "K", ":move '<-2<CR>gv-gv")
map('v', "<A-j>", ":move '>+1<CR>gv-gv")
map('v', "<A-k>", ":move '<-2<CR>gv-gv")

-- Diffview
map('n', '<leader>dv', ':DiffviewOpen<CR>')
map('n', '<leader>dh', ':DiffviewFileHistory<CR>')

-- Neo-tree
map('n', '<F2>', ':Neotree toggle<CR>')

-- Telescope
local builtin = require('telescope.builtin')
map('n', '<leader>ff', builtin.find_files)
map('n', '<leader>gr', builtin.live_grep)
map('n', '<leader>gs', builtin.grep_string)
map('n', '<leader>fh', builtin.help_tags)
map('n', '<leader>km', builtin.keymaps)
map('n', '<leader>rr', builtin.lsp_references)
map('n', '<leader>gd', builtin.lsp_definitions)
map('n', '<leader>gi', builtin.lsp_implementations)

-- Tagbar
map('n', '<F3>', ':TagbarToggle<CR>')

-- ToggleTerm
map('n', '<F4>', ':ToggleTerm<CR>')
map('t', '<F4>', [[<C-\><C-n> <Cmd>ToggleTerm<CR>]])
