local linter = require("lint")

-- Setup
linter.linters_by_ft = {
	lua = { "luacheck" },
	sh = { "shellcheck" },
	dockerfile = { "hadolint" },
	markdown = { "markdownlint", "proselint" }, -- textlint
	--text = { "vale", "proselint", "write_good" }, -- textlint
}

local try_lint = function()
	require("lint").try_lint()
end

-- Lint on Save
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "BufWinEnter" }, {
	pattern = {
		"CMakeLists.txt",
		"*.c",
		"*.h",
		"*.cpp",
		"*.hpp",
		"*.rs",
		"*.py",
		"*.lua",
		"*.sh",
		"Dockerfile",
		"*.html",
		"*.css",
		"*.md",
		"*.txt",
	},
	callback = try_lint,
})

------------------------------------------------------------------------------- Shellcheck
local shellcheck = require("lint.linters.shellcheck")
shellcheck.args = {
	"-x",
	"--format",
	"json",
	"-",
}
