local status_ok, mason = pcall(require, "mason")
if not status_ok then
  return
end

local servers = {
  "bashls",
  "clangd",
  "rust_analyzer",
  "bashls",
  "pylsp",
}

mason.setup{}
require("mason-lspconfig").setup({
  ensure_installed = servers,
  automatic_installation = false,
})

