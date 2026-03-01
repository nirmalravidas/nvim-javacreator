local M = {}

function M.setup(opts)
	local config = require("javacreator.config")
	config.setup(opts)
	local o = config.options

	require("javacreator.detect").setup(o)
	require("javacreator.creator").setup(o)
end

return M
