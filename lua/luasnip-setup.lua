local status_ok, _luasnip = pcall(require, "luasnip")
if not status_ok then return end

local s = _luasnip.snippet
local t = _luasnip.text_node
local i = _luasnip.insert_node

_luasnip.add_snippets("all", {
	-- trigger is `fn`, second argument to snippet-constructor are the nodes to insert into the buffer on expansion.
	s("ifnret", {
		-- Simple static text.
		t("if not "),
		i(0, "status_ok"),
		t(" then return end"),
	}),
})
