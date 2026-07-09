local status_ok, sidekick = pcall(require, "sidekick")
if not status_ok then
  return
end

sidekick.setup {
  nes = {
    enabled = true,
    clear = {
      -- events that clear the current next edit suggestion
      events = { "TextChangedI", "InsertEnter" },
      esc = false, -- clear next edit suggestions when pressing <Esc>
    },
  },
  cli = {
    win = {
      keys = {
        files         = { "<c-f>", "files"     , mode = "nt", desc = "open file picker" },
        prompt        = { "<c-p>", "prompt"    , mode = "t" , desc = "insert prompt or context" },
        stopinsert    = { "<c-q>", "stopinsert", mode = "t" , desc = "enter normal mode" },
        -- Navigate windows in terminal mode. Only active when:
        -- * layout is not "float"
        -- * there is another window in the direction
        -- With the default layout of "right", only `<c-h>` will be mapped
        nav_left      = { "<c-h>", "nav_left"  , expr = true, desc = "navigate to the left window" },
        nav_down      = { "<c-j>", "nav_down"  , expr = true, desc = "navigate to the below window" },
        nav_up        = { "<c-k>", "nav_up"    , expr = true, desc = "navigate to the above window" },
        nav_right     = { "<c-l>", "nav_right" , expr = true, desc = "navigate to the right window" },
      },
    }
  }
}

