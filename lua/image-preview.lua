TREES = {
	{
		name = 'nvim-tree',
		function_name = 'prev_nvim_tree',
		pattern = 'NvimTree',
	},
}

local config = {
	mappings = {
		PreviewImage = {
			{ 'n' },
			' p', -- <leader>p
		},
	},
	Options = {
		useFeh = true,
	},
}

local terminal_type = os.getenv('TERM')

TREE_FUNCTIONS = {
	prev_nvim_tree = function()
		local api = require('nvim-tree.api')
		local node = api.tree.get_node_under_cursor()
		vim.api.nvim_command('silent !feh -B black ' .. node.absolute_path)
	end,
}

local function get_tree_type()
	local function_name = nil
	local pattern = nil
	for _, plugin in ipairs(TREES) do
		local has_plugin, _ = pcall(require, plugin.name)
		if has_plugin then
			function_name = plugin.function_name
			pattern = plugin.pattern
			break
		end
	end

	return { function_name = function_name, pattern = pattern }
end

local function setup_autocmd(tree, keybind)
	vim.api.nvim_create_autocmd('FileType', {
		pattern = tree.pattern,
		callback = function()
			vim.keymap.set(keybind.modes, keybind.keybind, function()
				TREE_FUNCTIONS[tree.function_name]()
			end, { noremap = true, silent = true })
		end,
	})
end

local function setup(user_config)
	config = vim.tbl_deep_extend('force', config, user_config or {}) -- merge tables

	local preview_keybind = nil

	for action, mapping in pairs(config.mappings) do
		if action == 'PreviewImage' then
			preview_keybind = {
				modes = mapping[1],
				keybind = mapping[2],
			}
		end
	end

	local tree = get_tree_type()
	setup_autocmd(tree, preview_keybind)
end
return { setup = setup }
