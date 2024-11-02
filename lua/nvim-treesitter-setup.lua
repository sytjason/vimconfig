local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end
treesitter.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "bash", "c", "cpp", "css", "diff", "html", "lua", "make", "python", "typescript", "tsx", "jsonc" },

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    additional_vim_regex_highlighting = true,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "B", -- set to `false` to disable one of the mappings
      node_incremental = "<leader>ss",
      scope_incremental = "<leader>SS",
      node_decremental = "<leader>sk",
    },
  },

  indent = {
    enable = true,
  },

  refactor = {
    highlight_definitions = {
      enable = true,
      -- Set to false if you have an `updatetime` of ~100.
      clear_on_cursor_move = true,
    },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = "<leader>gnd",
        list_definitions = "<leader>gnD",
        list_definitions_toc = "<leader>gO",
        goto_next_usage = "<C-n>",
        goto_previous_usage = "<C-p>",
      },
    },
  },
}

vim.cmd('hi TreesitterContext gui=underline guisp=Grey')

