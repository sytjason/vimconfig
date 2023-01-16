local options = {
  shiftwidth    = 8,
  tabstop       = 8,
  mouse         = "a",
  smartindent   = true,
  smartcase     = true,
  incsearch     = true,
  hlsearch      = true,
  number        = true,
  autoread      = true,            -- auto load the buffer if the file has been changed outside of vim
  showmode      = false,           -- do not show mode on the message line, since it is shown in status line
  termguicolors = true,            -- enable true colors support
  splitbelow    = true,            -- force all horizontal splits to go below current window
  splitright    = true,            -- force all vertical splits to go to the right of current window
  wrap          = true,            -- display lines as one long line
  --laststatus    = 3,
}

local g_options = {
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
vim.cmd [[colorscheme nightfox]]
