-- Dependencies:
-- rg: ripgrep
-- fd: fd-find
require("telescope").setup({
	defaults = {
		dynamic_preview_title = true,
		layout_strategy = "vertical",
		layout_config = {
			vertical = {
				height = 0.9,
				preview_cutoff = 40,
				prompt_position = "top",
				width = 0.9,
			},
		},
		scroll_strategy = "limit",
	},
})

-- Extensions
require("telescope").load_extension("fzf")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-f>", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<C-p>", function()
	vim.ui.input({ prompt = "Search for: " }, function(input)
		if input then
			builtin.grep_string({ search = input })
		else
			print("No input provided.")
		end
	end)
end, { noremap = true, desc = "Telescope grep string" })

vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

vim.keymap.set("n", "gr", function()
	builtin.lsp_references({ show_line = false })
end, { desc = "Telescope lsp list references" })

vim.keymap.set("n", "gi", builtin.lsp_implementations, { desc = "Telescope lsp go[show] implementation[s]" })
vim.keymap.set("n", "gic", builtin.lsp_incoming_calls, { desc = "Telescope lsp " })
vim.keymap.set("n", "goc", builtin.lsp_outgoing_calls, { desc = "Telescope lsp " })
vim.keymap.set("n", "gd", function()
	builtin.lsp_definitions({ show_line = false })
end, { desc = "Telescope lsp go[show] definitions" })
--vim.keymap.set("n", "gw", builtin.lsp_workspace_diagnostics, { desc = "Telescope lsp " })
vim.keymap.set("n", "gy", builtin.lsp_document_symbols, { desc = "Telescope lsp show document symbols" })

vim.keymap.set("n", "<leader>fc", builtin.colorscheme, { desc = "Telescope <to-be defined>" })
vim.keymap.set("n", "<leader>fs", builtin.spell_suggest, { desc = "Telescope <to-be defined>" })

--vim.keymap.set("n", "<leader>fdv", builtin.dap_variables, { desc = "Telescope <to-be defined>" })
--vim.keymap.set("n", "<leader>fdf", builtin.dap_frames, { desc = "Telescope <to-be defined>" })

--vim.keymap.set("n", "<leader>ff", builtin.,               { desc = "Telescope <to-be defined>" })
