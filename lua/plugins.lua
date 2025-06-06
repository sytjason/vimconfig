local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerSync
augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

return packer.startup(function(use)
  use 'wbthomason/packer.nvim'
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use 'MunifTanjim/nui.nvim' -- Required by neotree
  use 'nvim-lua/plenary.nvim'
  use 'cossonleo/dirdiff.nvim'
  use {'nvim-neo-tree/neo-tree.nvim', branch = "v3.x"}
  use 'stevearc/oil.nvim'
  use 'preservim/tagbar'
  use 'sindrets/diffview.nvim'
  use 'AndrewRadev/linediff.vim'
  use 'kyazdani42/nvim-web-devicons'
  use 'lukas-reineke/indent-blankline.nvim'
  use {"akinsho/toggleterm.nvim", tag = '*'}
  use 'gpanders/editorconfig.nvim'
  use 'jbyuki/venn.nvim'
  use 'filipdutescu/renamer.nvim'

  --
  -- Selector
  --
  use 'nvim-telescope/telescope.nvim'

  --
  -- AI
  --
  use 'github/copilot.vim'
  use 'CopilotC-Nvim/CopilotChat.nvim'

  --
  -- editing
  --
  use 'numToStr/Comment.nvim'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-surround'
  use {
    'echasnovski/mini.nvim',
    version = false
  }

  --
  -- looking
  --
  use 'goolord/alpha-nvim'
  use 'projekt0n/github-nvim-theme'
  use 'EdenEast/nightfox.nvim'
  use 'rebelot/kanagawa.nvim'

  --
  -- status bar
  --
  -- use 'nvim-lualine/lualine.nvim'
  use {
    'rebelot/heirline.nvim',
    requires = {'lewis6991/gitsigns.nvim'},
  }
  use "b0o/incline.nvim"
  use 'SmiteshP/nvim-navic'

  --
  -- treesitter
  --
  use {
    'nvim-treesitter/nvim-treesitter-refactor',
    requires = {'nvim-treesitter/nvim-treesitter'},
  }
  -- use 'nvim-treesitter/nvim-treesitter-context'

  --
  -- lsp
  --
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'onsails/lspkind.nvim'

  --
  -- auto completion
  --
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'

  --
  -- snippets
  --
  use 'L3MON4D3/LuaSnip'
  use 'hrsh7th/cmp-nvim-lua'
  use 'saadparwaiz1/cmp_luasnip'
  use 'rafamadriz/friendly-snippets'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
