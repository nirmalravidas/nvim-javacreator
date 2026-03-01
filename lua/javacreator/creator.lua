-- lua/javacreator/creator.lua
local M = {}

local function get_template_dir()
	-- Method 1: lazy plugin path
	local lazy_path = vim.fn.stdpath("data") .. "/lazy/nvim-javacreator"
	if vim.fn.isdirectory(lazy_path) == 1 then
		local path = lazy_path .. "/lua/javacreator/templates"
		if vim.fn.isdirectory(path) == 1 then
			return path
		end
	end

	-- Method 2: runtime path
	for _, rtp in ipairs(vim.api.nvim_list_runtime_paths()) do
		if rtp:match("nvim%-javacreator$") then
			local path = rtp .. "/lua/javacreator/templates"
			if vim.fn.isdirectory(path) == 1 then
				return path
			end
		end
	end

	return nil
end

local function get_template(template_name)
	local dir = get_template_dir()
	if not dir then
		vim.notify("javacreator: templates directory not found", vim.log.levels.ERROR)
		return nil
	end
	local path = dir .. "/" .. template_name .. ".java"
	local file = io.open(path, "r")
	if not file then
		vim.notify("javacreator: template not found: " .. path, vim.log.levels.ERROR)
		return nil
	end
	local content = file:read("*all")
	file:close()
	return content
end

local function get_target_dir()
	-- check if neo-tree is focused
	if vim.bo.filetype == "neo-tree" then
		local ok, manager = pcall(require, "neo-tree.sources.manager")
		if ok then
			local state_ok, state = pcall(function()
				return manager.get_state("filesystem")
			end)
			if state_ok and state and state.tree then
				local node_ok, node = pcall(function()
					return state.tree:get_node()
				end)
				if node_ok and node then
					local path_ok, path = pcall(function()
						return node.path or node:get_id()
					end)
					if path_ok and path then
						if vim.fn.isdirectory(path) == 1 then
							return path
						else
							return vim.fn.fnamemodify(path, ":h")
						end
					end
				end
			end
		end
	end

	-- current java file directory
	local bufname = vim.api.nvim_buf_get_name(0)
	if bufname ~= "" and bufname:match("%.java$") then
		local dir = vim.fn.fnamemodify(bufname, ":p:h")
		if vim.fn.isdirectory(dir) == 1 then
			return dir
		end
	end

	-- fallback to src/main/java
	local cwd = vim.fn.getcwd()
	local java_src = cwd .. "/src/main/java"
	if vim.fn.isdirectory(java_src) == 1 then
		return java_src
	end

	return cwd
end

local function create_file(dir, choice, name)
	local package = dir:match("src/main/java/(.+)") or ""
	package = package:gsub("/", ".")

	local content = get_template(choice.template)
	if not content then
		return
	end

	content = content:gsub("${NAME}", name)
	content = content:gsub("${PACKAGE}", package)
	content = content:gsub("${PATH}", name:lower())
	content = content:gsub("${TABLE}", name:lower() .. "s")

	local filepath = dir .. "/" .. name .. ".java"

	if vim.fn.filereadable(filepath) == 1 then
		vim.notify("javacreator: file already exists: " .. name .. ".java", vim.log.levels.ERROR)
		return
	end

	local file = io.open(filepath, "w")
	if not file then
		vim.notify("javacreator: could not create: " .. filepath, vim.log.levels.ERROR)
		return
	end
	file:write(content)
	file:close()

	vim.cmd("edit " .. vim.fn.fnameescape(filepath))
	vim.notify("javacreator: created " .. name .. ".java", vim.log.levels.INFO)

	-- refresh jdtls only for java projects
	vim.defer_fn(function()
		if vim.g.javacreator_project_type == "java" then
			pcall(function()
				vim.cmd("JdtUpdateConfig")
			end)
		end
	end, 1000)
end

function M.setup(opts)
	if not opts.creator.enabled then
		return
	end

	vim.keymap.set("n", opts.creator.keymap, function()
		local target_dir = get_target_dir()

		vim.ui.select({
			"Yes — create here: " .. target_dir,
			"No — pick different folder",
		}, { prompt = "Create file in:" }, function(answer)
			if not answer then
				return
			end

			local function proceed(dir)
				vim.ui.select(opts.creator.types, {
					prompt = "Select Java File Type:",
					format_item = function(item)
						return item.label
					end,
				}, function(choice)
					if not choice then
						return
					end
					vim.ui.input({ prompt = "Class Name: " }, function(name)
						if not name or name == "" then
							return
						end
						create_file(dir, choice, name)
					end)
				end)
			end

			if answer:match("^Yes") then
				proceed(target_dir)
			else
				vim.ui.input({
					prompt = "Enter directory path: ",
					default = target_dir,
					completion = "dir",
				}, function(dir)
					if dir and vim.fn.isdirectory(dir) == 1 then
						proceed(dir)
					else
						vim.notify("javacreator: invalid directory: " .. (dir or ""), vim.log.levels.ERROR)
					end
				end)
			end
		end)
	end, { desc = "New Java File", silent = true })
end

return M
