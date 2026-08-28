-- Show line numbers
vim.opt.number = true
-- set the highlight for line number
vim.opt.cul = true
-- enable true colors support
vim.opt.termguicolors = true

-- enable mouse support for normal mode
-- useful for dap-ui repl
vim.opt.mouse = "nv"
-- Use always clipboard
vim.opt.clipboard = "unnamedplus"

vim.opt.laststatus = 0

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local opts = {
	checker = { enabled = false },
	defaults = { lazy = false },
}

local plugins = {
	-- colorschemes
	{
		priority = 100,
		"sainnhe/gruvbox-material",
		config = function()
			vim.g.gruvbox_material_enable_italic = true
			vim.g.gruvbox_material_background = "medium"
			vim.cmd([[colorscheme gruvbox-material]])
		end,
	},

	-- Documenting
	{
		"kthenrique/adoc-live.nvim",
		build = "npm install",
		config = function()
			require("adoc_live").setup()
		end,
	},

	-- Treesitter (syntax highlighting)
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(vim.treesitter.start)
				end,
			})
		end,
		config = function()
			local function register_adoc_parsers()
				local parsers = require("nvim-treesitter.parsers")
				parsers.asciidoc = {
					install_info = {
						url = "https://github.com/cathaysia/tree-sitter-asciidoc",
						files = { "tree-sitter-asciidoc/src/parser.c", "tree-sitter-asciidoc/src/scanner.c" },
						branch = "master",
						location = "tree-sitter-asciidoc",
						queries = "queries/asciidoc/",
						requires = { "asciidoc_inline" },
					},
				}
				parsers.asciidoc_inline = {
					install_info = {
						url = "https://github.com/cathaysia/tree-sitter-asciidoc",
						files = { "tree-sitter-asciidoc_inline/src/parser.c" },
						branch = "master",
						location = "tree-sitter-asciidoc_inline",
						queries = "queries/asciidoc_inline",
					},
				}
			end

			vim.api.nvim_create_autocmd("User", {
				pattern = "TSUpdate",
				callback = register_adoc_parsers,
			})

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local ft = vim.bo[args.buf].filetype
					if ft == "" then
						return
					end
					local lang = vim.treesitter.language.get_lang(ft)
					if lang and not pcall(vim.treesitter.language.add, lang) then
						require("nvim-treesitter").install({ lang })
					end
				end,
			})
		end,
	},

	-- Beautifier
	{
		"lukas-reineke/indent-blankline.nvim", -- indent marks
		config = function()
			require("ibl").setup()
		end,
	},
	{
		"norcalli/nvim-colorizer.lua", -- show colors in code
		config = function()
			require("colorizer").setup()
		end,
	},

	-- Convenience Tools
	{
		"https://codeberg.org/andyg/leap.nvim",
		config = function()
			vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
			vim.keymap.set("n", "S", "<Plug>(leap-anywhere)")
		end,
	}, -- Motions
}

require("lazy").setup(plugins, opts)
