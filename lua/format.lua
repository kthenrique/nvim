------------------------------------------------------------------------------- FORMATTING

require("formatter").setup({
	filetype = {
		lua = { require("formatter.filetypes.lua").stylua },
		["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace },
	},
})

-- Format on Save
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.lua", "*.rs", "*.cpp", "*.c", "*.h", "*.hpp", "*.py", "*.svelte", "*.dart" },
	command = "FormatWrite",
})
