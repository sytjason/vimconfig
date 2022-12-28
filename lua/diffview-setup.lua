local status_ok, diffview = pcall(require, "diffview")
if not status_ok then
	return
end

local actions = require("diffview.actions")
diffview.setup{
	watch_index = false,
	view = {
		merge_tool = {
			layout = "diff3_mixed",
		},
	},
	keymaps = {
		view = {
			{ "n", "gf", actions.goto_file_tab, { desc = "Open the file in a new tab" } },
		},
		file_panel = {
			{ "n", "gf", actions.goto_file_tab, { desc = "Open the file in a new tab" } },
		},
		file_history_panel = {
			{ "n", "gf", actions.goto_file_tab, { desc = "Open the file in a new tab" } },
		},
	},
}
