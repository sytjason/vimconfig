local status_ok, _luasnip = pcall(require, "luasnip")
if not status_ok then return end

local s = _luasnip.snippet
local t = _luasnip.text_node
local i = _luasnip.insert_node

_luasnip.add_snippets("lua", {
    s("loc", {
      t("local status_ok, "),
      i(1, "_package"),
      t(" = pcall(require, "),
      i(0, "\"package\""),
      t(")"),
      t("if not status_ok then return end"),
    }),
  }
)

