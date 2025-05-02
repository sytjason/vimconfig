local status_ok, copilotchat = pcall(require, "CopilotChat")
if not status_ok then
  return
end

vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true

copilotchat.setup{}
