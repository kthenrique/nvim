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
}

local plugins = {
	-- colorschemes
	{
		lazy = false,
		priority = 1000,
		"sainnhe/gruvbox-material",
		config = function()
			vim.g.gruvbox_material_enable_italic = true
			vim.g.gruvbox_material_background = "medium"
			vim.cmd([[colorscheme gruvbox-material]])
		end,
	},
	{ "rebelot/kanagawa.nvim", priority = 1000, config = true },

	{ "kyazdani42/nvim-web-devicons", lazy = true },
	-- Start screen
	{ "mhinz/vim-startify" },

	-- installer manager
	{ "williamboman/mason.nvim", dependencies = { "williamboman/mason-lspconfig.nvim" } },

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
	{ "dcampos/nvim-snippy" }, -- snippets engine
	{ "honza/vim-snippets" }, -- snippets source

	-- Linter engine
	{ "mfussenegger/nvim-lint" },

	-- Debugging
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },

	-- Formatting
	{ "mhartington/formatter.nvim" },

	-- Windows repositioning
	{
		"sindrets/winshift.nvim",
		config = function()
			vim.api.nvim_set_keymap("n", "<C-W><C-X>", "<Cmd>WinShift<CR>", { noremap = true })
		end,
	},

	-- Statusline
	{
		"NTBBloodbath/galaxyline.nvim",
		branch = "main",
		dependencies = { "kyazdani42/nvim-web-devicons" },
	},
	--use 'famiu/feline.nvim'

	-- File explorer
	{ "kyazdani42/nvim-tree.lua", dependencies = "kyazdani42/nvim-web-devicons" },

	-- Buffer tabs
	{ "akinsho/nvim-bufferline.lua", dependencies = "kyazdani42/nvim-web-devicons" },

	-- Documenting
	{
		"brianhuster/live-preview.nvim",
		dependencies = {
			-- You can choose one of the following pickers
			"nvim-telescope/telescope.nvim",
			"ibhagwan/fzf-lua",
			"echasnovski/mini.pick",
		},
	},

	-- Git integration
	{ "lewis6991/gitsigns.nvim", dependencies = "nvim-lua/plenary.nvim" },
	{ "sindrets/diffview.nvim", dependencies = "nvim-lua/plenary.nvim" },

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

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter", -- code introspection/colorizing
		build = ":TSUpdate",
	},
	{ "hiphish/rainbow-delimiters.nvim" }, -- brackets colors
	{ "nvim-treesitter/nvim-treesitter-context" }, -- show context

	-- Convenience Tools
	{
		"folke/which-key.nvim", -- Helper for mapped keys
		event = "VeryLazy",
	},
	{ "numToStr/FTerm.nvim" }, -- Terminal utilities
	{ "booperlv/nvim-gomove" }, -- inputs repositioning
	{
		"ggandor/leap.nvim",
		config = function()
			require("leap").add_default_mappings()
		end,
	}, -- Motions

	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
	},

	-- Experimental ------------------------------------------------------------------------
	{ "Civitasv/cmake-tools.nvim" }, -- cmake
	{
		"stevearc/overseer.nvim",
		config = function()
			require("overseer").setup()
		end,
	},
	{ -- GitHub
		"pwntester/octo.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			-- OR 'ibhagwan/fzf-lua',
			-- OR 'folke/snacks.nvim',
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("octo").setup()
		end,
	},
}

require("lazy").setup(plugins, opts)
