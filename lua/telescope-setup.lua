local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require "telescope.actions"
local themes = require "telescope.themes"

telescope.setup {
  -- ivy as the global default: merge the theme's own opts into `defaults`.
  defaults = vim.tbl_deep_extend("force", themes.get_ivy(), {
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "smart" },
    layout_config = {
      preview_width = 0.6,
    },
    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<C-c>"] = actions.close,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,

        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-l>"] = actions.complete_tag,
        --["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
      },

      n = {
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["H"] = actions.move_to_top,
        ["M"] = actions.move_to_middle,
        ["L"] = actions.move_to_bottom,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["?"] = actions.which_key,
      },
    },
  }),
}

local builtin = require('telescope.builtin')

local function map(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { desc = desc })
end

map('<leader>ff', builtin.find_files, "Find files")
map('<leader>zz', builtin.current_buffer_fuzzy_find, "Fuzzy find in buffer")
map('<leader>gr', builtin.live_grep, "Live grep")
map('<leader>gs', builtin.grep_string, "Grep string under cursor")
map('<leader>fh', builtin.help_tags, "Help tags")
map('<leader>km', builtin.keymaps, "Keymaps")
map('<leader>rr', builtin.lsp_references, "LSP references")
map('<leader>gd', builtin.lsp_definitions, "LSP definitions")
map('<leader>gi', builtin.lsp_implementations, "LSP implementations")
map('<leader>gb', builtin.git_branches, "Git branches")
map('<leader>cm', builtin.commands, "Commands")
map('<leader>ma', function() builtin.man_pages({ sections = { 'ALL' } }) end, "Man pages")
map('<leader>ic', builtin.lsp_incoming_calls, "LSP incoming calls")
map('<leader>oc', builtin.lsp_outgoing_calls, "LSP outgoing calls")
