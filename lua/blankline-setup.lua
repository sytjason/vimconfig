local status_ok, blankline = pcall(require, "ibl")
if not status_ok then
  return
end

blankline.setup {}
