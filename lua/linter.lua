local linter = require("lint")

-- Setup
linter.linters_by_ft = {
	cmake = { "cmakelint" }, -- "cmakelang"
	c = { "codespell" },
	cpp = { "codespell" },
	rust = { "clippy" },
	python = {}, --'pylint'},                    -- bandit
	lua = { "luacheck" },
	sh = { "shellcheck" },
	dockerfile = { "hadolint" },
	html = { "proselint" },
	css = { "stylelint" },
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

------------------------------------------------------------------------------- Clang-Tidy
local clangtidy = require("lint.linters.clangtidy")
clangtidy.args = {
	"--checks=*,-modernize-use-trailing-return-type,-llvmlibc*,-portability-restrict-system-includes,-llvm-header-guard",
	"-p=./build",
	"--config-file=.clang-tidy",
}

-------------------------------------------------------------------------------- Cmakelint
local cmakelint = require("lint.linters.cmakelint")
cmakelint.args = {
	"--filter=-linelength",
}

----------------------------------------------------------------------------------- Flake8
-- ignore:
--   - E221: multiple spaces before operator
--   - E501: line too long
--   - N802: function name should be lowercase
local flake = require("lint.linters.flake8")
flake.args = {
	"--format=%(path)s:%(row)d:%(col)d:%(code)s:%(text)s",
	"--ignore=E221,E501,N802",
	"--no-show-source",
	"-",
}

------------------------------------------------------------------------------- Shellcheck
local shellcheck = require("lint.linters.shellcheck")
shellcheck.args = {
	"-x",
	"--format",
	"json",
	"-",
}
