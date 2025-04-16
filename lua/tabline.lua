-- colors for active , inactive uffer tabs
require("bufferline").setup({
	options = {
		buffer_close_icon = "",
		show_buffer_close_icons = true,
		show_close_icon = false,
		max_name_length = 14,
		max_prefix_length = 13,
		enforce_regular_tabs = true,
		view = "multiwindow",
		separator_style = "slant",
		always_show_bufferline = true,
		sort_by = "tabs",
		custom_filter = function(bufn)
			-- get a list of buffers for current tab
			local tab_buffers = vim.fn.tabpagebuflist()
			-- check if the current buffer is being viewed in the current tab
			return vim.tbl_contains(tab_buffers, bufn)
		end,
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				highlight = "Directory",
			},
		},
	},
})

local opt = { silent = true }

-- tabnew and tabprev
vim.api.nvim_set_keymap("n", "<A-p>", [[<Cmd>BufferLinePick<CR>]], opt)
