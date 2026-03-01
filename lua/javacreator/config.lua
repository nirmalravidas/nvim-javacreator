local M = {}

M.defaults = {
	detect = {
		enabled = true,
		auto_create_neoconf = true,
		notify = true,
	},
	creator = {
		enabled = true,
		keymap = "<leader>jn",
		types = {
			{ label = "Class", template = "class" },
			{ label = "Interface", template = "interface" },
			{ label = "Enum", template = "enum" },
			{ label = "Record", template = "record" },
			{ label = "Annotation", template = "annotation" },
			{ label = "REST Controller", template = "controller" },
			{ label = "Service", template = "service" },
			{ label = "Repository", template = "repository" },
			{ label = "Entity", template = "entity" },
			{ label = "Component", template = "component" },
			{ label = "Configuration", template = "config" },
		},
	},
}

M.options = {}

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

return M
