local status_ok, heirline = pcall(require, "heirline")
if not status_ok then
  vim.notify("heirline-setup: heirline.nvim is not available", vim.log.levels.WARN)
  return
end

local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

-- get_highlight() returns an empty table for groups the active colorscheme does
-- not define (nightfox has no `diffDeleted`, for instance). That leaves the
-- color name undefined, and heirline then hands the *name* straight to
-- nvim_set_hl at render time -- "Invalid highlight color: 'git_del'" -- which
-- kills the entire statusline. So try a list of groups and always end on a
-- literal fallback.
local function hl_attr(attr, groups, fallback)
  for _, group in ipairs(groups) do
    local value = utils.get_highlight(group)[attr]
    if value then
      return value
    end
  end
  return fallback
end

local function setup_colors()
  return {
    bright_bg = hl_attr("bg", { "Folded" }, "#3b4048"),
    bright_fg = hl_attr("fg", { "Folded" }, "#a0a8b7"),
    red = hl_attr("fg", { "DiagnosticError" }, "#e06c75"),
    dark_red = hl_attr("bg", { "DiffDelete" }, "#3f2d3d"),
    green = hl_attr("fg", { "String" }, "#98c379"),
    blue = hl_attr("fg", { "Function" }, "#61afef"),
    gray = hl_attr("fg", { "NonText" }, "#5c6370"),
    orange = hl_attr("fg", { "Constant" }, "#d19a66"),
    purple = hl_attr("fg", { "Statement" }, "#c678dd"),
    cyan = hl_attr("fg", { "Special" }, "#56b6c2"),
    diag_warn = hl_attr("fg", { "DiagnosticWarn" }, "#e5c07b"),
    diag_error = hl_attr("fg", { "DiagnosticError" }, "#e06c75"),
    diag_hint = hl_attr("fg", { "DiagnosticHint" }, "#56b6c2"),
    diag_info = hl_attr("fg", { "DiagnosticInfo" }, "#61afef"),
    git_del = hl_attr("fg", { "diffDeleted", "Removed", "GitSignsDelete" }, "#e06c75"),
    git_add = hl_attr("fg", { "diffAdded", "Added", "GitSignsAdd" }, "#98c379"),
    git_change = hl_attr("fg", { "diffChanged", "Changed", "GitSignsChange" }, "#d19a66"),
  }
end
-- local colors = require'kanagawa.colors'.setup()

local ViMode = {
  -- get vim current mode, this information will be required by the provider
  -- and the highlight functions, so we compute it only once per component
  -- evaluation and store it as a component attribute
  init = function(self)
    self.mode = vim.fn.mode(1) -- :h mode()
  end,
  -- Now we define some dictionaries to map the output of mode() to the
  -- corresponding string and color. We can put these into `static` to compute
  -- them at initialisation time.
  static = {
    mode_names = { -- change the strings if you like it vvvvverbose!
      n = "N",
      no = "N?",
      nov = "N?",
      noV = "N?",
      ["no\22"] = "N?",
      niI = "Ni",
      niR = "Nr",
      niV = "Nv",
      nt = "Nt",
      v = "V",
      vs = "Vs",
      V = "V_",
      Vs = "Vs",
      ["\22"] = "^V",
      ["\22s"] = "^V",
      s = "S",
      S = "S_",
      ["\19"] = "^S",
      i = "I",
      ic = "Ic",
      ix = "Ix",
      R = "R",
      Rc = "Rc",
      Rx = "Rx",
      Rv = "Rv",
      Rvc = "Rv",
      Rvx = "Rv",
      c = "C",
      cv = "Ex",
      r = "...",
      rm = "M",
      ["r?"] = "?",
      ["!"] = "!",
      t = "T",
    },
    mode_colors = {
      n = "red" ,
      i = "green",
      v = "cyan",
      V =  "cyan",
      ["\22"] =  "cyan",
      c =  "orange",
      s =  "purple",
      S =  "purple",
      ["\19"] =  "purple",
      R =  "orange",
      r =  "orange",
      ["!"] =  "red",
      t =  "red",
    }
  },
  -- We can now access the value of mode() that, by now, would have been
  -- computed by `init()` and use it to index our strings dictionary.
  -- note how `static` fields become just regular attributes once the
  -- component is instantiated.
  -- To be extra meticulous, we can also add some vim statusline syntax to
  -- control the padding and make sure our string is always at least 2
  -- characters long. Plus a nice Icon.
  provider = function(self)
    return " %2("..self.mode_names[self.mode].."%)"
  end,
  -- Same goes for the highlight. Now the foreground will change according to the current mode.
  hl = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    return { fg = self.mode_colors[mode], bold = true, }
  end,
  -- Re-evaluate the component only on ModeChanged event!
  -- Also allows the statusline to be re-evaluated when entering operator-pending mode
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
      vim.cmd("redrawstatus")
    end),
  },
}

local FileNameBlock = {
  -- let's first set up some attributes needed by this component and its children
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
}
-- We can now define some children separately and add them later

local FileIcon = {
  init = function(self)
    local ok, devicons = pcall(require, "nvim-web-devicons")
    if not ok then
      return
    end
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color = devicons.get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end
}

local FileName = {
  provider = function(self)
    -- first, trim the pattern relative to the current directory. For other
    -- options, see :h filename-modifers
    -- fall back to the buffer name so this component also works on its own,
    -- outside of FileNameBlock (which is what sets self.filename)
    local filename = vim.fn.fnamemodify(self.filename or vim.api.nvim_buf_get_name(0), ":.")
    if filename == "" then return "[No Name]" end
    -- now, if the filename would occupy more than 1/4th of the available
    -- space, we trim the file path to its initials
    -- See Flexible Components section below for dynamic truncation
    if not conditions.width_percent_below(#filename, 0.25) then
      filename = vim.fn.pathshorten(filename)
    end
    return filename
  end,
  hl = { fg = utils.get_highlight("Directory").fg },
}

local FileFlags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = "[+]",
    hl = { fg = "green" },
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = "",
    hl = { fg = "orange" },
  },
}

local FileNameModifer = {
  hl = function()
    if vim.bo.modified then
      -- use `force` because we need to override the child's hl foreground
      return { fg = "cyan", bold = true, force=true }
    end
  end,
}

-- let's add the children to our FileNameBlock component
FileNameBlock = utils.insert(FileNameBlock,
FileIcon,
utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
FileFlags,
{ provider = '%<'} -- this means that the statusline is cut here when there's not enough space
)

local FileType = {
  provider = function()
    return string.upper(vim.bo.filetype)
  end,
  hl = { fg = utils.get_highlight("Type").fg, bold = true },
}

local FileEncoding = {
  provider = function()
    local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc -- :h 'enc'
    return enc ~= 'utf-8' and enc:upper()
  end,
  hl = { fg = utils.get_highlight("Type").fg, bold = true },
}

local FileFormat = {
  provider = function()
    local fmt = vim.bo.fileformat
    return fmt ~= 'unix' and fmt:upper()
  end,
  hl = { fg = utils.get_highlight("Type").fg, bold = true },
}

-- We're getting minimalist here!
local Ruler = {
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  provider = "%7(%l/%3L%):%2c %P",
}

local LSPActive = {
  condition = conditions.lsp_attached,
  update = {'LspAttach', 'LspDetach'},

  -- You can keep it simple,
  provider = " [LSP]",

  -- Or complicate things a bit and get the servers names
  -- provider = function()
  --   local names = {}
  --   for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
  --     table.insert(names, server.name)
  --   end
  --   return " [" .. table.concat(names, " ") .. "]"
  -- end,
  hl = { fg = "green", bold = true },
}

-- I personally use it only to display progress messages!
-- See lsp-status/README.md for configuration options.

-- Note: check "j-hui/fidget.nvim" for a nice statusline-free alternative.
-- local LSPMessages = {
--   provider = require("lsp-status").status,
--   hl = { fg = "gray" },
-- }

-- Awesome plugin

-- Full nerd (with icon colors and clickable elements)!
-- works in multi window, but does not support flexible components (yet ...)
local Navic = {
  condition = function()
    local ok, navic = pcall(require, "nvim-navic")
    return ok and navic.is_available()
  end,
  static = {
    -- create a type highlight map
    type_hl = {
      File = "Directory",
      Module = "@include",
      Namespace = "@namespace",
      Package = "@include",
      Class = "@structure",
      Method = "@method",
      Property = "@property",
      Field = "@field",
      Constructor = "@constructor",
      Enum = "@field",
      Interface = "@type",
      Function = "@function",
      Variable = "@variable",
      Constant = "@constant",
      String = "@string",
      Number = "@number",
      Boolean = "@boolean",
      Array = "@field",
      Object = "@type",
      Key = "@keyword",
      Null = "@comment",
      EnumMember = "@field",
      Struct = "@structure",
      Event = "@keyword",
      Operator = "@operator",
      TypeParameter = "@type",
    },
    -- bit operation dark magic, see below...
    enc = function(line, col, winnr)
      local b = require("bit")
      return b.bor(b.lshift(line, 16), b.lshift(col, 6), winnr)
    end,
    -- line: 16 bit (65535); col: 10 bit (1023); winnr: 6 bit (63)
    dec = function(c)
      local b = require("bit")
      local line = b.rshift(c, 16)
      local col = b.band(b.rshift(c, 6), 1023)
      local winnr = b.band(c, 63)
      return line, col, winnr
    end
  },
  init = function(self)
    local data = require("nvim-navic").get_data() or {}
    local children = {}
    -- create a child for each level
    for i, d in ipairs(data) do
      -- encode line and column numbers into a single integer
      local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
      local child = {
        {
          provider = d.icon,
          hl = self.type_hl[d.type],
        },
        {
          -- escape `%`s (elixir) and buggy default separators
          provider = d.name:gsub("%%", "%%%%"):gsub("%s*->%s*", ''),
          -- highlight icon only or location name as well
          -- hl = self.type_hl[d.type],

          on_click = {
            -- pass the encoded position through minwid
            minwid = pos,
            callback = function(_, minwid)
              -- decode
              local line, col, winnr = self.dec(minwid)
              vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), {line, col})
            end,
            name = "heirline_navic",
          },
        },
      }
      -- add a separator only if needed
      if #data > 1 and i < #data then
        table.insert(child, {
          provider = " > ",
          hl = { fg = 'bright_fg' },
        })
      end
      table.insert(children, child)
    end
    -- instantiate the new child, overwriting the previous one
    self.child = self:new(children, 1)
  end,
  -- evaluate the children containing navic components
  provider = function(self)
    return self.child:eval()
  end,
  hl = { fg = "gray" },
  update = 'CursorMoved'
}

local git_stats = { added = 0, removed = 0 }
local git_stats_running = false

local function refresh_git_stats()
  if git_stats_running then
    return
  end
  git_stats_running = true
  vim.system(
    -- --no-optional-locks: a statusline poll must never write .git/index.lock
    { "git", "--no-optional-locks", "diff", "--numstat" },
    { cwd = vim.fn.getcwd(), text = true },
    function(out)
      git_stats_running = false
      local added, removed = 0, 0
      if out.code == 0 then
        -- binary files are reported as "-\t-\t<path>" and simply do not match
        for a, r in (out.stdout or ""):gmatch("(%d+)\t(%d+)\t") do
          added = added + tonumber(a)
          removed = removed + tonumber(r)
        end
      end
      if added ~= git_stats.added or removed ~= git_stats.removed then
        git_stats = { added = added, removed = removed }
        vim.schedule(function()
          vim.cmd.redrawstatus()
        end)
      end
    end
  )
end

local GitHead = {
  condition = function()
    return (vim.g.gitsigns_head or "") ~= ""
  end,
  hl = { fg = "orange" },
  {
    provider = function()
      return " " .. vim.g.gitsigns_head
    end,
    hl = { bold = true },
  },
  {
    condition = function()
      return git_stats.added > 0 or git_stats.removed > 0
    end,
    { provider = "(" },
    {
      condition = function()
        return git_stats.added > 0
      end,
      provider = function()
        return "+" .. git_stats.added
      end,
      hl = { fg = "git_add" },
    },
    {
      condition = function()
        return git_stats.removed > 0
      end,
      provider = function()
        return "-" .. git_stats.removed
      end,
      hl = { fg = "git_del" },
    },
    { provider = ")" },
  },
}

local TerminalName = {
  -- we could add a condition to check that buftype == 'terminal'
  -- or we could do that later (see #conditional-statuslines below)
  provider = function()
    local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
    return " " .. tname
  end,
  hl = { fg = "blue", bold = true },
}

local HelpFileName = {
  condition = function()
    return vim.bo.filetype == "help"
  end,
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ":t")
  end,
  hl = { fg = "blue" },
}

vim.opt.showcmdloc = 'statusline'
local Align = { provider = "%=" }
local Space = { provider = " " }

ViMode = utils.surround({ "", "" }, "bright_bg", { ViMode })

local DefaultStatusline = {
  ViMode, Space, FileNameBlock, Space, GitHead, Space, Align,
  Navic, Align, LSPActive, Space, Space, Space, FileType, Space,
  FileEncoding, Space, FileFormat, Space, Ruler, Space
}
local InactiveStatusline = {
  condition = conditions.is_not_active,
  -- FileNameBlock, not FileName: self.filename is set by FileNameBlock's init()
  FileType, Space, FileNameBlock, Align,
}
local SpecialStatusline = {
  condition = function()
    return conditions.buffer_matches({
      buftype = { "nofile", "prompt", "help", "quickfix" },
      filetype = { "^git.*", "fugitive" },
    })
  end,

  FileType, Space, HelpFileName, Align
}
local TerminalStatusline = {

  condition = function()
    return conditions.buffer_matches({ buftype = { "terminal", } })
  end,

  hl = { bg = "dark_red" },

  -- Quickly add a condition to the ViMode to only show it when buffer is active!
  { condition = conditions.is_active, ViMode, Space }, FileType, Space, TerminalName, Space, GitHead, Space, Align,
}

local StatusLines = {

  hl = function()
    if conditions.is_active() then
      return "StatusLine"
    else
      return "StatusLineNC"
    end
  end,

  -- the first statusline with no condition, or which condition returns true is used.
  -- think of it as a switch case with breaks to stop fallthrough.
  fallthrough = false,

  SpecialStatusline, TerminalStatusline, InactiveStatusline, DefaultStatusline,
}

heirline.setup({
  statusline = StatusLines,
  opts = {
    colors = setup_colors,
  },
})

vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        utils.on_colorscheme(setup_colors)
    end,
    group = "Heirline",
})

-- Keep GitHead's worktree counts fresh. GitSignsUpdate covers edits to files
-- gitsigns is attached to; the rest catch changes made outside this nvim (a
-- commit or checkout in the terminal buffer itself, most obviously).
vim.api.nvim_create_autocmd({ "BufWritePost", "DirChanged", "FocusGained", "TermLeave" }, {
    callback = refresh_git_stats,
    group = "Heirline",
})
vim.api.nvim_create_autocmd("User", {
    pattern = "GitSignsUpdate",
    callback = refresh_git_stats,
    group = "Heirline",
})
refresh_git_stats()
