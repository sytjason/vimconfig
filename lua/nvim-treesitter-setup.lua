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


-- ---------------------------------------------------------------------------
-- nvim-treesitter-textobjects (branch: main)
-- ---------------------------------------------------------------------------
local to_ok, textobjects = pcall(require, "nvim-treesitter-textobjects")
if not to_ok then
  return
end

textobjects.setup {
  select = {
    -- jump forward to the textobject if the cursor is not already inside one
    lookahead = true,
    lookbehind = false,
    selection_modes = {
      ['@parameter.outer'] = 'v', -- charwise
      ['@function.outer']  = 'V', -- linewise
      ['@class.outer']     = 'V', -- linewise
    },
    include_surrounding_whitespace = false,
  },
  move = {
    set_jumps = true, -- record motions in the jumplist so <C-o> works
  },
}

local ts_select = require("nvim-treesitter-textobjects.select")
local ts_move   = require("nvim-treesitter-textobjects.move")
local ts_swap   = require("nvim-treesitter-textobjects.swap")

-- select ---------------------------------------------------------------------
local function sel(lhs, query, desc)
  vim.keymap.set({ 'x', 'o' }, lhs, function()
    ts_select.select_textobject(query, "textobjects")
  end, { desc = desc })
end

sel('af', '@function.outer',    'a function')
sel('if', '@function.inner',    'inner function')
sel('ac', '@class.outer',       'a class')
sel('ic', '@class.inner',       'inner class')
sel('aa', '@parameter.outer',   'a parameter')
sel('ia', '@parameter.inner',   'inner parameter')
sel('al', '@loop.outer',        'a loop')
sel('il', '@loop.inner',        'inner loop')
sel('ak', '@conditional.outer', 'a conditional')
sel('ik', '@conditional.inner', 'inner conditional')

-- move -----------------------------------------------------------------------
local function mv(lhs, fn, query, desc)
  vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
    fn(query, "textobjects")
  end, { desc = desc })
end

-- [[ / ]] jump between functions (replaces the built-in section motions)
mv(']]', ts_move.goto_next_start,     '@function.outer', 'Next function start')
mv('[[', ts_move.goto_previous_start, '@function.outer', 'Previous function start')
mv('][', ts_move.goto_next_end,       '@function.outer', 'Next function end')
mv('[]', ts_move.goto_previous_end,   '@function.outer', 'Previous function end')

-- swap -----------------------------------------------------------------------
vim.keymap.set('n', '<leader>sa', function()
  ts_swap.swap_next("@parameter.inner")
end, { desc = "Swap parameter with next" })
vim.keymap.set('n', '<leader>sA', function()
  ts_swap.swap_previous("@parameter.inner")
end, { desc = "Swap parameter with previous" })

-- Make the treesitter motions above repeatable with ; and , (also makes the
-- builtin f/F/t/T repeatable). Uncomment to opt in.
-- local ts_repeat = require("nvim-treesitter-textobjects.repeatable_move")
-- vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat.repeat_last_move_next)
-- vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat.repeat_last_move_previous)
-- vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat.builtin_f_expr, { expr = true })
-- vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat.builtin_F_expr, { expr = true })
-- vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat.builtin_t_expr, { expr = true })
-- vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat.builtin_T_expr, { expr = true })

-- The runtime ftplugins (python, rust, go, php, vim, ruby, help, markdown, ...)
-- define [[ and ]] as *buffer-local* maps, which beat the global ones above.
-- Drop those so the treesitter motions win. Filetypes where [[ / ]] is a
-- heading motion rather than a code motion are left alone.
local keep_builtin_brackets = {
  help = true, markdown = true, checkhealth = true, man = true, vimdoc = true,
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function(args)
    if keep_builtin_brackets[vim.bo[args.buf].filetype] then
      return
    end
    for _, mode in ipairs({ 'n', 'x', 'o' }) do
      for _, lhs in ipairs({ '[[', ']]', '][', '[]' }) do
        pcall(vim.keymap.del, mode, lhs, { buffer = args.buf })
      end
    end
  end,
})
