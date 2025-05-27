local status_ok, mason = pcall(require, "mason")
if not status_ok then
  return
end

-- :h mason-lspconfig-server-map
local servers_map = {
  ["bash-language-server"] = "bashls",
  ["clangd"]               = "clangd",
  ["python-lsp-server"]    = "pylsp",
  ["gopls"]                = "gopls",
  ["lua-language-server"]  = "lua_ls",
  ["json-lsp"]             = "jsonls",
  ["rust-analyzer"]        = "rust-analyzer",
}

local ensured = {}

for _server,_lsp in pairs(servers_map) do
  if vim.fn.executable(_server) ~= 1 then
    table.insert(ensured, _lsp)
  end
end

mason.setup{}
require("mason-lspconfig").setup({
  ensure_installed = ensured,
  automatic_installation = false,
})

