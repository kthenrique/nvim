vim.g.nvim_tree_auto_ignore_ft = { "startify", "dashboard" } -- empty by default, don't auto open tree on specific filetypes.
vim.g.nvim_tree_width_allow_resize = 1 --0 by default, will not resize the tree when opening a file

vim.api.nvim_set_keymap("n", "<F2>", ":NvimTreeFocus<CR>", {
	noremap = true,
	silent = true,
})

require("nvim-tree").setup({
	-- disables netrw completely
	disable_netrw = true,
	-- opens the tree when changing/opening a new tab if the tree wasn't previously opened
	open_on_tab = false,
	-- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually)
	update_cwd = true,
	view = {
		width = 40,
	},
	-- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
	renderer = {
		add_trailing = true,
		group_empty = true,
		highlight_git = true,
		highlight_opened_files = "all",
		indent_markers = {
			enable = true,
			icons = {
				corner = "└ ",
				edge = "│ ",
				none = "  ",
			},
		},
	},
	update_focused_file = {
		-- enables the feature
		enable = false,
		-- update the root directory of the tree to the one of the folder containing the file if the file is not under the current root directory
		-- only relevant when `update_focused_file.enable` is true
		update_cwd = false,
		-- list of buffer names / filetypes that will not update the cwd if the file isn't found under the current root directory
		-- only relevant when `update_focused_file.update_cwd` is true and `update_focused_file.enable` is true
		ignore_list = {},
	},
	git = {
		ignore = false, -- show git ignored files
	},
})
