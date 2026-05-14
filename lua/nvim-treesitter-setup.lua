local status_ok, treesitter = pcall(require, "nvim-treesitter")
if not status_ok then
  return
end

-- New API: setup only accepts install_dir
treesitter.setup {}

-- Install parsers (no-op if already installed)
treesitter.install {
  "bash", "c", "cpp", "css", "diff", "html", "lua", "make", "python",
  "typescript", "tsx", "vimdoc", "luadoc", "vim", "markdown",
}

-- Highlighting, folding, and indentation are now enabled per-filetype
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    local ok = pcall(vim.treesitter.start)
    if not ok then return end

    -- vim.wo[0][0].foldmethod = 'expr'
    -- vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

vim.cmd('hi TreesitterContext gui=underline guisp=Grey')

