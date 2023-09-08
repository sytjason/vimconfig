-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end


local diag_config = {
  -- disable virtual text
  virtual_text = false,
  -- show signs
  signs = {
    active = signs,
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

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local _on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  --vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "gl",
    '<cmd>lua vim.diagnostic.open_float()<CR>',
    opts
  )
end


local status_ok, _lspconfig = pcall(require, "lspconfig")
if not status_ok then return end

local _cmd
if vim.fn.hostname() == "SHNBS"
then
  _cmd = {"/home/linuxbrew/.linuxbrew/bin/clangd"}
else
  _cmd = {"clangd"}
end

_lspconfig['clangd'].setup {
  on_attach = _on_attach,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  cmd = _cmd,
  filetypes = {"c", "cpp", "proto"},
}

_lspconfig['lua_ls'].setup{
  on_attach = _on_attach,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

_lspconfig.astro.setup{
  on_attach = _on_attach,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
}

_lspconfig.bashls.setup{
  on_attach = _on_attach,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  filetypes = {"sh"},
}


_lspconfig.rust_analyzer.setup{
  on_attach = _on_attach,
  capabilities = vim.lsp.protocol.make_client_capabilities()
}
