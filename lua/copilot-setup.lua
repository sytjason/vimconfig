local status_ok, copilot = pcall(require, "copilot")
if not status_ok then
  return
end

copilot.setup {
  suggestion = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      accept = "<C-M-l>",
    }
  },
  panel = {
    enabled = false,
  },
  -- Allow copilot in AgenticInput buffers (buftype = "nofile")
  should_attach = function(bufnr, bufname)
    local filetype = vim.bo[bufnr].filetype

    if filetype == "AgenticInput" then
      return true
    end

    local default_should_attach = require("copilot.config.should_attach").default
    return default_should_attach(bufnr, bufname)
  end,
}
