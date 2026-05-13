local diag_config = {
  virtual_lines = {
    current_line = true
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󰠠 ",
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = "Error",
      [vim.diagnostic.severity.WARN]  = "Warn",
      [vim.diagnostic.severity.INFO]  = "Info",
      [vim.diagnostic.severity.HINT]  = "Hint",
    },
  },
  update_in_insert = true,
  underline        = true,
  severity_sort    = true,
  float = {
    focusable = false,
    style     = "minimal",
    border    = "rounded",
    source    = "always",
    header    = "",
    prefix    = "",
  },
}

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.keymap.set("n", "K", function()
      vim.lsp.buf.hover({ border = "rounded" })
    end, { buffer = args.buf, desc = "Hover" })
  end,
})

vim.diagnostic.config(diag_config)
vim.lsp.enable({ 'clangd', 'lua_ls', 'bashls', 'jsonls', 'pylsp' })
