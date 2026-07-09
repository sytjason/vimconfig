local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit...", "ErrorMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "nvim-lua/popup.nvim",
  "MunifTanjim/nui.nvim",
  "nvim-lua/plenary.nvim",
  { "nvim-neo-tree/neo-tree.nvim", branch = "v3.x" },
  "stevearc/oil.nvim",
  "preservim/tagbar",
  "AndrewRadev/linediff.vim",
  "kyazdani42/nvim-web-devicons",
  "lukas-reineke/indent-blankline.nvim",
  { "akinsho/toggleterm.nvim", version = "*" },
  "gpanders/editorconfig.nvim",
  "jbyuki/venn.nvim",
  "filipdutescu/renamer.nvim",
  "folke/snacks.nvim",

  -- Git
  -- "sindrets/diffview.nvim",
  { "esmuellert/codediff.nvim", cmd = "CodeDiff" },
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      -- For a custom log pager
      "m00qek/baleia.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
    }
  },

  -- Selector
  "nvim-telescope/telescope.nvim",

  -- AI
  "zbirenbaum/copilot.lua",
  "CopilotC-Nvim/CopilotChat.nvim",
  "carlos-algms/agentic.nvim",
  "folke/sidekick.nvim",

  -- editing
  "numToStr/Comment.nvim",
  "tpope/vim-fugitive",
  "tpope/vim-surround",
  { "echasnovski/mini.nvim", version = false },

  -- looking
  "goolord/alpha-nvim",
  "projekt0n/github-nvim-theme",
  "EdenEast/nightfox.nvim",
  "rebelot/kanagawa.nvim",

  -- status bar
  -- { "nvim-lualine/lualine.nvim" },
  {
    "rebelot/heirline.nvim",
    dependencies = { "lewis6991/gitsigns.nvim" },
  },
  "b0o/incline.nvim",
  "SmiteshP/nvim-navic",

  -- treesitter
  {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate'
  },
  -- { -- deprecated due to newer treesitter
  --   "nvim-treesitter/nvim-treesitter-refactor",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  -- },
  -- { "nvim-treesitter/nvim-treesitter-context" },

  -- lsp
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "onsails/lspkind.nvim",

  -- auto completion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",

  -- snippets
  "L3MON4D3/LuaSnip",
  "hrsh7th/cmp-nvim-lua",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
})
