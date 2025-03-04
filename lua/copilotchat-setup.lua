local status_ok, copilotchat = pcall(require, "CopilotChat")
if not status_ok then
  return
end

copilotchat.setup{}
