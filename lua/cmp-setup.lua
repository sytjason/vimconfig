local status_ok, cmp = pcall(require, "cmp")
if not status_ok then
	return
end

local sn_status_ok, luasnip = pcall(require, "luasnip")
if not sn_status_ok then
	return
end

local lsp_status_ok, lspkind = pcall(require, "lspkind")
if not lsp_status_ok then
	return
end

require("luasnip.loaders.from_vscode").lazy_load() -- Using existing vs-code style snippets from a plugin ,rafamadriz/friendly-snippets

local check_backspace = function()
	local col = vim.fn.col "." - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

cmp.setup{
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			 require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = {
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),

		['<C-b>'] = cmp.mapping.scroll_docs(-1),
		['<C-f>'] = cmp.mapping.scroll_docs(1),
		--['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expandable() then
				luasnip.expand()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif check_backspace() then
				fallback()
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	},
	formatting = {
		format = function(entry, vim_item)
			if vim.tbl_contains({ 'path' }, entry.source.name) then
				local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
				if icon then
					vim_item.kind = icon
					vim_item.kind_hl_group = hl_group
					return vim_item
				end
			end
			return lspkind.cmp_format({ with_text = false })(entry, vim_item)
		end
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'buffer' },
		{ name = 'path' },
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
}

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
--cmp.setup.cmdline(':', {
	--mapping = cmp.mapping.preset.cmdline(),
	--sources = cmp.config.sources({
		--{ name = 'path' }
	--}, {
		--{ name = 'cmdline' }
	--})
--})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['clangd'].setup {
	capabilities = capabilities
}
require('lspconfig')['sumneko_lua'].setup {
	capabilities = capabilities
}
