------------------------------------------------------------------------------- FORMATTING

-- cpp
local clangFmt = function()
	return {
		exe = "clang-format",
		args = { "--style=file", "--assume-filename", vim.api.nvim_buf_get_name(0) },
		stdin = true,
		try_node_modules = true,
		cwd = vim.fn.expand("%:p:h"), -- Run clang-format in cwd of the file.
	}
end

local cmakeFmt = function()
	return {
		exe = "gersemi",
		args = { "--in-place", "-" },
		stdin = true,
		cwd = vim.fn.expand("%:p:h"),
	}
end
require("formatter").setup({
	filetype = {
		html = { require("formatter.filetypes.html").prettier },
		css = { require("formatter.filetypes.css").prettier },
		typescript = { require("formatter.filetypes.typescript").prettier },
		javascript = { require("formatter.filetypes.javascript").prettier },
		vue = { require("formatter.filetypes.vue").prettier },
		svelte = { require("formatter.filetypes.svelte").prettier },
		lua = { require("formatter.filetypes.lua").stylua },
		dart = { require("formatter.filetypes.dart").dartformat },
		rust = { require("formatter.filetypes.rust").rustfmt },
		cpp = { clangFmt },
		c = { clangFmt },
		cmake = { cmakeFmt },
		python = { require("formatter.filetypes.python").ruff },
		["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace },
	},
})

-- Format on Save
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.lua", "*.rs", "*.cpp", "*.c", "*.h", "*.hpp", "*.py", "*.svelte", "*.dart" },
	command = "FormatWrite",
})
