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
map('n', '=', '<C-W>+')
map('n', '-', '<C-W>-')
map('n', '+', '<C-W>>')
map('n', '_', '<C-W><')

-- Move text up and down
map('v', 'J', ":move '>+1<CR>gv-gv")
map('v', 'K', ":move '<-2<CR>gv-gv")
map('v', '<A-j>', ":move '>+1<CR>gv-gv")
map('v', '<A-k>', ":move '<-2<CR>gv-gv")

-- CodeDiff
map('n', '<leader>cd', ':CodeDiff<CR>')
map('n', '<leader>ch', ':CodeDiff history<CR>')

-- file explorer
map('n', '<C-f>', function() require("oil").toggle_float() end)

-- toggle diagnostic
map('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end)

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

-- renamer
map({ 'n', 'v' }, '<leader>rn', '<cmd>lua require("renamer").rename()<cr>')

-- toggle line num
map('n', '<leader>nu', toggleLinenum)

-- sidekick
map({ 'n', 't' }, '<C-`>', function() require('sidekick.cli').toggle({ name = "copilot" }) end)
map('v', '<C-,>', function() require("sidekick.cli").send({ msg = "{this}" }) end)
map('n', '<C-.>', function() require("sidekick.cli").send({ msg = "{file}" }) end)
map('n', '<leader>l', function() require("sidekick.nes").apply() end)

-- toggleterm easy navigation
local function set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

vim.api.nvim_create_autocmd('TermOpen', {
  pattern = 'term://*',
  callback = set_terminal_keymaps,
})

map({'n' ,'t'}, '<c-\\>', function() require("toggleterm-setup").toggle_terminal() end)
