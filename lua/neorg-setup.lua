local status_ok, _neorg = pcall(require, "neorg")
if not status_ok then return end

_neorg.setup{
  load = {
    ["core.defaults"] = {},

    ["core.export"] = {},

    ["core.keybinds"] = {
      -- just show some keybinds I might use [Ref]{neorg/modules/core/keybinds/keybinds.lua}
      --keybinds.map_event_to_mode("norg", {
      ---- Creates a new .norg file to take notes in
      ---- ^New Note
      --{ leader .. "nn", "core.norg.dirman.new.note" },

      ---- Same as `<CR>`, except opens the destination in a vertical split
      --{ "<M-CR>", "core.norg.esupports.hop.hop-link", "vsplit" },
      --},
      --keybinds.map_to_mode("all", {
      --n = {
      --{ leader .. "mn", ":Neorg mode norg<CR>" },
      --{ leader .. "mh", ":Neorg mode traverse-heading<CR>" },
      --{ "gO", ":Neorg toc split<CR>" },
      --},
      --},
    },

    ["core.dirman"] = {
      config = {
        workspaces = {
          work = "~/Documents/study/note/work",
          home = "~/Documents/study/note/home",
          neorg = "~/Documents/study/note/neorg",
        },
      },
    },

    ["core.completion"] = {
      config = {
        engine = "nvim-cmp",
      },
    },

    ["core.concealer"] = {
      config = {
        folds = false;
      },
    },

    ["core.integrations.treesitter"] = {
      config = { -- Note that this table is optional and doesn't need to be provided
        -- Configuration here
      },
    },
  },
}
