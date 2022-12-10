local status_ok, ofirkai = pcall(require, "ofirkai")
if not status_ok then
	return
end

ofirkai.setup{}
