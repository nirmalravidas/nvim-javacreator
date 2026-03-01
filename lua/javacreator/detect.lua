local M = {}

local neoconf_templates = {
	java = {
		lspconfig = {
			jdtls = { enabled = true },
			vscode_spring_boot_tools = { enabled = true },
			pyright = { enabled = false },
			clangd = { enabled = false },
			vtsls = { enabled = false },
			tailwindcss = { enabled = false },
		},
	},
	react = {
		lspconfig = {
			vtsls = { enabled = true },
			tailwindcss = { enabled = true },
			jdtls = { enabled = false },
			pyright = { enabled = false },
			clangd = { enabled = false },
		},
	},
	python = {
		lspconfig = {
			pyright = { enabled = true },
			ruff = { enabled = true },
			jdtls = { enabled = false },
			clangd = { enabled = false },
			vtsls = { enabled = false },
			tailwindcss = { enabled = false },
		},
	},
	cpp = {
		lspconfig = {
			clangd = { enabled = true },
			jdtls = { enabled = false },
			pyright = { enabled = false },
			vtsls = { enabled = false },
			tailwindcss = { enabled = false },
		},
	},
}

local project_names = {
	java = "Spring Boot Project",
	react = "React Project",
	python = "Python Project",
	cpp = "C++ Project",
}

local function detect_type(cwd)
	if vim.fn.glob(cwd .. "/pom.xml") ~= "" or vim.fn.glob(cwd .. "/build.gradle") ~= "" then
		return "java"
	elseif vim.fn.glob(cwd .. "/package.json") ~= "" then
		return "react"
	elseif vim.fn.glob(cwd .. "/requirements.txt") ~= "" or vim.fn.glob(cwd .. "/pyproject.toml") ~= "" then
		return "python"
	elseif vim.fn.glob(cwd .. "/CMakeLists.txt") ~= "" or vim.fn.glob(cwd .. "/*.cpp") ~= "" then
		return "cpp"
	end
	return nil
end

function M.setup(opts)
	if not opts.detect.enabled then
		return
	end

	vim.api.nvim_create_autocmd("VimEnter", {
		once = true,
		callback = function()
			vim.defer_fn(function()
				local cwd = vim.fn.getcwd()
				local neoconf_path = cwd .. "/.neoconf.json"
				local project_type = detect_type(cwd)

				if not project_type then
					return
				end

				vim.g.javacreator_project_type = project_type

				if vim.fn.filereadable(neoconf_path) == 1 then
					if opts.detect.notify then
						vim.notify("javacreator: " .. project_names[project_type], vim.log.levels.INFO)
					end
					return
				end

				if opts.detect.auto_create_neoconf then
					local content = vim.fn.json_encode(neoconf_templates[project_type])
					local result = vim.fn.writefile({ content }, neoconf_path)
					if result == 0 and opts.detect.notify then
						vim.notify(
							"javacreator: " .. project_names[project_type] .. "\n" .. ".neoconf.json created",
							vim.log.levels.INFO
						)
					end
				end
			end, 100)
		end,
	})
end

return M
