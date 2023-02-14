local status_ok, mason = pcall(require, "mason")
if not status_ok then
  return
end

local servers = {
  "lua_ls",
  "clangd",
  "rust_analyzer"
}

mason.setup{}
require("mason-lspconfig").setup({
  ensure_installed = servers,
  automatic_installation = false,
})

