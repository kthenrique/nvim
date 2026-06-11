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
	{ "rebelot/kanagawa.nvim", config = true },

	-- Statusline
	{
		priority = 90,
		"NTBBloodbath/galaxyline.nvim",
		branch = "main",
		dependencies = { "kyazdani42/nvim-web-devicons" },
	},
	--use 'famiu/feline.nvim'

	{ "kyazdani42/nvim-web-devicons" },
	-- Start screen
	{ "mhinz/vim-startify" },

	-- installer manager
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
	},

	-- LSP
	{ "neovim/nvim-lspconfig" }, -- default config for multiple langs
	{
		"j-hui/fidget.nvim", -- view lsp processing progress
	},

	-- Completion
	{
		"hrsh7th/nvim-cmp", -- completion engine
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- addon for native lsp
			"dcampos/cmp-snippy", -- addon for nvim-snippy
			"hrsh7th/cmp-buffer", -- addon for buffer completions
			"hrsh7th/cmp-path", -- addon for path completions
			"hrsh7th/cmp-nvim-lua", -- addon for plugin dev in lua
			"hrsh7th/cmp-nvim-lsp-signature-help", -- addon for signatures
		},
	},

	-- Snippets
	{ "dcampos/nvim-snippy", event = "InsertEnter" }, -- snippets engine
	{ "honza/vim-snippets", event = "InsertEnter" }, -- snippets source

	-- Linter engine
	{ "mfussenegger/nvim-lint" },

	-- Debugging
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },

	-- Formatting
	{ "mhartington/formatter.nvim" },

	-- Windows repositioning
	{
		keys = { "<C-W><C-X>" },
		"sindrets/winshift.nvim",
		config = function()
			vim.api.nvim_set_keymap("n", "<C-W><C-X>", "<Cmd>WinShift<CR>", { noremap = true })
		end,
	},

	-- File explorer
	{ "kyazdani42/nvim-tree.lua", dependencies = "kyazdani42/nvim-web-devicons" },

	-- Buffer tabs
	{ "akinsho/nvim-bufferline.lua", dependencies = "kyazdani42/nvim-web-devicons" },

	-- Documenting
	{
		"kthenrique/adoc-live.nvim",
		build = "npm install",
		config = function()
			require("adoc_live").setup()
		end,
	},
	{
		"3rd/image.nvim",
		build = false,
		opts = {
			processor = "magick_cli",
			integrations = {
				asciidoc = {
					only_render_image_at_cursor = true,
					only_render_image_at_cursor_mode = "inline",
				},
			},
		},
	},
	{
		"kthenrique/diagram.nvim",
		branch = "adoc-feats",
		opts = {
			renderer_options = {
				mermaid = {
					background = "transparent",
				},
			},
		},
	},

	-- Git integration
	{ "lewis6991/gitsigns.nvim", dependencies = "nvim-lua/plenary.nvim" },
	{ cmd = "DiffviewOpen", "sindrets/diffview.nvim", dependencies = "nvim-lua/plenary.nvim" },

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
		"folke/which-key.nvim", -- Helper for mapped keys
		event = "VeryLazy",
	},
	{ "numToStr/FTerm.nvim" }, -- Terminal utilities
	{ "booperlv/nvim-gomove" }, -- inputs repositioning
	{
		"https://codeberg.org/andyg/leap.nvim",
		config = function()
			vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
			vim.keymap.set("n", "S", "<Plug>(leap-anywhere)")
		end,
	}, -- Motions

	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
	},

	-- LLM
	{
		"github/copilot.vim",
		version = "*",
		config = function()
			vim.g.copilot_no_tab_map = true
			vim.keymap.set("i", "<leader><leader>", 'copilot#Accept("\\<CR>")', {
				expr = true,
				replace_keycodes = false,
				silent = true,
			})
		end,
	},

	{
		"nickjvandyke/opencode.nvim",
		version = "*",
	},
	-- Experimental ------------------------------------------------------------------------
	{
		"stevearc/overseer.nvim",
		config = function()
			require("overseer").setup()
		end,
	},

	{ "kevinhwang91/nvim-bqf", ft = "qf" },
}

require("lazy").setup(plugins, opts)
