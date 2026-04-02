local status_ok, agentic = pcall(require, "agentic")
if not status_ok then
  return
end

agentic.setup {
  provider = "copilot-acp",
  keymaps = {
    widget = {
      switch_model = "<leader>m",
    }
  }
}
