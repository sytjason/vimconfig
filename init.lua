vim.cmd([[
  filetype plugin indent on    " required

  " autocomplete dropdown list colorscheme
  hi Pmenu ctermfg=0 ctermbg=7
  hi PmenuSel ctermfg=7 ctermbg=4

  " Update the cscope files on startup of cscope.
  " Defaults to off
  let g:cscope_update_on_start = 1


]])

-- Common editor setup
require('plugins')
require('options')
require('keymaps')

-- Plugins setup
require('diffview-setup')
require('github-theme-setup')
--require('ofirkai-setup')
require('lualine-setup')
require('neoscroll-setup')
require('nvim-tree-setup')
