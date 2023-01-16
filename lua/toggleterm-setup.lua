local status_ok, _toggle_term = pcall(require, "toggleterm")
if not status_ok then return end

_toggle_term.setup{
  direction = "float",
}

