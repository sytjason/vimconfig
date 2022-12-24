local function map (mode, lhs, rhs)
  vim.keymap.set(mode, lhs, rhs, {})
end

-- Navigations between panes
map('n', '<C-j>', '<C-W>j')
map('n', '<C-k>', '<C-W>k')
map('n', '<C-h>', '<C-W>h')
map('n', '<C-l>', '<C-W>l')

-- Diffview
map('n', '<leader>dv', ':DiffviewOpen<CR>')
map('n', '<leader>dh', ':DiffviewFileHistory<CR>')

-- Nvim-tree
map('n', '<F2>', ':NvimTreeToggle<CR>')

-- Telescope
local builtin = require('telescope.builtin')
map('n', '<leader>f', builtin.find_files)
map('n', '<leader>gr', builtin.live_grep)
map('n', '<leader>gs', builtin.grep_string)
map('n', '<leader>fh', builtin.help_tags)
map('n', '<leader>km', builtin.keymaps)
map('n', '<leader>r', builtin.lsp_references)
map('n', '<leader>gd', builtin.lsp_definitions)

-- Tagbar
map('n', '<F3>', ':TagbarToggle<CR>')
