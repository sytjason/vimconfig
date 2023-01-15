local status_ok, mason = pcall(require, "mason")
if not status_ok then
	return
end

local servers = {
	"sumneko_lua",
	"clangd",
}

mason.setup{}
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = false,
})

