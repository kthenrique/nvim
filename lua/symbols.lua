------------------------------------------------------------------------------- TREESITTER
require("treesitter-context").setup({
	separator = "—",
	zindex = 20, -- The Z-index of the context window
})
vim.api.nvim_set_keymap("", "<C-c>", "<Cmd>TSContextToggle<CR>", { noremap = true })

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"vim",
		"vimdoc",
	},
	auto_install = true,
	highlight = {
		enable = true,
		use_languagetree = true,
	},
	rainbow = {
		enable = true,
		extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
		max_file_lines = nil, -- Do not enable for files with more than n lines, int
	},
})

vim.wo.foldenable = false
