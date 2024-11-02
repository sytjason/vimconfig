-- Required for image.nvim
-- package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
-- package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"

-- Common editor setup
require('plugins')
require('options')
require('keymaps')

-- Plugins setup
require('diffview-setup')
require('devicon-setup')
-- require('lualine-setup')
-- require('incline-setup')
require('heirline-setup')
require('luasnip-setup')
require('renamer-setup')
require('nvim-treesitter-setup')
require('oil-setup')
require('blankline-setup')
require('telescope-setup')
require('mason-setup')
require('cmp-setup')
require('lsp')
require('alpha-setup')
require('neotree-setup')
require('toggleterm-setup')
require('venn-setup')
require('nightfox-setup')
require('kanagawa-setup')
require("comment-setup")
