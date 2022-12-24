local status_ok, mason = pcall(require, "mason")
if not status_ok then
	return
end

local lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not lspconfig_status_ok then
	return
end

local servers = {
	"sumneko_lua",
	"clangd",
}

mason.setup{}
mason_lspconfig.setup{
	ensure_installed = servers,
	automatic_installation = true,
}

