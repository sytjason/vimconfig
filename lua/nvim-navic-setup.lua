local status_ok, nvim_navic = pcall(require, "nvim-navic")if not status_ok then return end

nvim_navic.setup {
  lsp = {
    auto_attach = true,
  }
}
