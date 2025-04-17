--dependencies
-- luacheck depends on luarocks
require("mason").setup({
	max_concurrent_installers = 10,
})
require("mason-lspconfig").setup()

local ensure_installed = {
	-- LSP
	"clangd", -- C/C++
	"rust-analyzer", -- Rust
	"cmake-language-server", -- CMake
	"bash-language-server", -- Bash
	"typescript-language-server", -- Typescript
	"html-lsp", -- HTML
	"css-lsp", -- CSS
	"svelte-language-server", -- Svelte
	"json-lsp", -- JSON
	"lua-language-server", -- LUA
	"marksman", -- Markdown
	"prosemd-lsp", -- proofreading & lint 4 Markdown
	"lemminx", -- XML
	"python-lsp-server", -- PyLSP
	"ruff-lsp", -- Python rust-implemented lsp
	"dockerfile-language-server", --- Dockerfile
	"yaml-language-server", -- YAML

	-- DAP
	"codelldb", -- C/C++

	-- Linter
	"codespell", -- *
	"cmakelang", -- CMake
	"cmakelint", -- CMake
	"shellcheck", -- Bash
	"stylelint", -- CSS
	"markdownlint", -- Markdown
	"proselint", -- txt, tex
	"textlint", -- txt
	"write-good", -- txt, tex
	"vale", -- txt, tex
	"hadolint", -- Dockerfile
	"luacheck", -- LUA

	-- Formatter
	"rustfmt", -- C/C++
	"clang-format", -- C/C++
	"gersemi", -- CMake
	"prettier", -- Web tools
	"stylua", -- LUA
	"ruff", -- python
}

-- Ensure all tools are installed at start-up
vim.api.nvim_create_autocmd({ "VimEnter" }, {
	callback = function()
		local mr = require("mason-registry")
		mr.refresh(function()
			for _, tool in ipairs(ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end)
	end,
})
