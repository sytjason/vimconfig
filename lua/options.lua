local options = {
  shiftwidth     = 4,
  tabstop        = 4,
  expandtab      = true,
  mouse          = "a",
  smartindent    = true,
  smartcase      = true,
  incsearch      = true,
  ignorecase     = true,
  hlsearch       = true,
  number         = true,
  relativenumber = true,
  swapfile       = false,
  autoread       = true,
  showmode       = false,
  termguicolors  = true,
  splitbelow     = true,
  splitright     = true,
  wrap           = true,
  timeoutlen     = 1000,
  scrolloff      = 8,
}

local g_options = {
  mapleader                = ' ',
  clipboard                = 'osc52',
  quickr_cscope_use_qf_g   = 1,
  quickr_cscope_keymaps    = 1,
  cscope_map_keys          = 1,
  cpp_attributes_highlight = 1,
  cpp_member_highlight     = 1,
  cpp_simple_highlight     = 1,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

for k, v in pairs(g_options) do
  vim.g[k] = v
end

vim.cmd('set laststatus=3')
