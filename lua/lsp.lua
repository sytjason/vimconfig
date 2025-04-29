-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions

local diag_config = {
  virtual_text = {
    spacing = 20,
    severity = vim.diagnostic.severity.ERROR
  },
  -- show signs
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󰠠 ",
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = "Error",
      [vim.diagnostic.severity.WARN] = "Warn",
      [vim.diagnostic.severity.INFO] = "Info",
      [vim.diagnostic.severity.HINT] = "Hint",
    },
  },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}

-- Enable border for hover
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

vim.diagnostic.config(diag_config)

vim.lsp.enable({'clangd', 'lua_ls', 'bashls', 'jsonls', 'rust_analyzer', 'pylsp', 'gopls'})

---------------------------------------
--- this is the old nvim-lspconfig ----
---------------------------------------
--- since neovim 0.11, nvim is integrated with lsp-config

-- -- Use an on_attach function to only map the following keys
-- -- after the language server attaches to the current buffer
-- local _on_attach = function(client, bufnr)
--   local opts = { noremap = true, silent = true }
--   vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
--
--   -- Mappings.
--   -- See `:help vim.lsp.*` for documentation on any of the below functions
--   local bufopts = { noremap = true, silent = true, buffer = bufnr }
--   vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
--   vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
--   vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
--   vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
--   --vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
--
--   vim.api.nvim_buf_set_keymap(
--     bufnr,
--     "n",
--     "gl",
--     '<cmd>lua vim.diagnostic.open_float()<CR>',
--     opts
--   )
--
--   -- nvim-navic
--   if client.server_capabilities.documentSymbolProvider then
--     local navic = require("nvim-navic")
--     navic.attach(client, bufnr)
--   end
-- end
--
--
-- local status_ok, _lspconfig = pcall(require, "lspconfig")
-- if not status_ok then return end
-- _lspconfig['clangd'].setup {
--   on_attach = _on_attach,
--   capabilities = vim.lsp.protocol.make_client_capabilities(),
--   cmd = _cmd,
--   filetypes = {"c", "cpp", "proto"},
-- }
--
--
-- _lspconfig['lua_ls'].setup{
--   on_attach = _on_attach,
--   capabilities = vim.lsp.protocol.make_client_capabilities(),
--   settings = {
--     Lua = {
--       runtime = {
--         -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--         version = 'LuaJIT',
--       },
--       diagnostics = {
--         -- Get the language server to recognize the `vim` global
--         globals = {'vim'},
--       },
--       workspace = {
--         -- Make the server aware of Neovim runtime files
--         library = vim.api.nvim_get_runtime_file("", true),
--         checkThirdParty = false,
--       },
--       -- Do not send telemetry data containing a randomized but unique identifier
--       telemetry = {
--         enable = false,
--       },
--     },
--   },
-- }
--
-- _lspconfig.bashls.setup{
--   on_attach = _on_attach,
--   capabilities = vim.lsp.protocol.make_client_capabilities(),
--   filetypes = {"sh"},
-- }
--
-- _lspconfig.jsonls.setup{
--   on_attach = _on_attach,
--   capabilities = vim.lsp.protocol.make_client_capabilities(),
--   filetypes = {"json"},
-- }
--
-- _lspconfig.rust_analyzer.setup{
--   on_attach = _on_attach,
--   capabilities = vim.lsp.protocol.make_client_capabilities()
-- }
--
-- _lspconfig.pylsp.setup{
--   on_attach = _on_attach,
--   capabilities = vim.lsp.protocol.make_client_capabilities()
-- }
--
-- _lspconfig.gopls.setup{
--   on_attach = _on_attach,
--   capabilities = vim.lsp.protocol.make_client_capabilities()
-- }
