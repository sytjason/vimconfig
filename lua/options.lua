local options = {
  shiftwidth     = 4,
  tabstop        = 4,
  expandtab      = true;
  mouse          = "a",
  smartindent    = true,
  smartcase      = true,
  incsearch      = true,
  ignorecase     = true,
  hlsearch       = true,
  number         = true,
  relativenumber = true,
  swapfile       = false,
  autoread       = true,     -- auto load the buffer if the file has been changed outside of vim
  showmode       = false,    -- do not show mode on the message line, since it is shown in status line
  termguicolors  = true,     -- enable true colors support
  splitbelow     = true,     -- force all horizontal splits to go below current window
  splitright     = true,     -- force all vertical splits to go to the right of current window
  wrap           = true,     -- display lines as one long line
  --laststatus   = 3,
  timeoutlen     = 1000,
  scrolloff      = 8,
}

local g_options = {
  quickr_cscope_use_qf_g   = 1,
  quickr_cscope_keymaps    = 1,
  cscope_map_keys          = 1,
  cpp_attributes_highlight = 1,
  cpp_member_highlight     = 1,
  cpp_simple_highlight     = 1,
  mapleader                = ' ',
}

local vim_cmds = {
  'set laststatus=3',
  -- 'colorscheme nightfox',
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

for k, v in pairs(g_options) do
  vim.g[k] = v
end

for _, cmd in ipairs(vim_cmds) do
  vim.cmd(cmd)
end
