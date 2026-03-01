-- plugin/javacreator.lua
if vim.g.loaded_javacreator then
	return
end
vim.g.loaded_javacreator = true

vim.api.nvim_create_user_command("JavaCreatorNew", function()
	local ok, config = pcall(require, "javacreator.config")
	if ok and config.options and config.options.creator then
		require("javacreator.creator").setup(config.options)
	end
end, { desc = "Create new Java file" })

vim.api.nvim_create_user_command("JavaCreatorInfo", function()
	local project_type = vim.g.javacreator_project_type or "unknown"
	local cwd = vim.fn.getcwd()
	local neoconf = vim.fn.filereadable(cwd .. "/.neoconf.json") == 1
	vim.notify(
		"javacreator info:\n"
			.. "  project type : "
			.. project_type
			.. "\n"
			.. "  .neoconf.json: "
			.. (neoconf and "exists" or "not found")
			.. "\n"
			.. "  cwd          : "
			.. cwd,
		vim.log.levels.INFO
	)
end, { desc = "Show project info" })
