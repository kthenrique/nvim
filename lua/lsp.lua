----------------------------------------------------------------------- LSP AUTOCOMPLETION
-- symbols for autocomplete
local CompletionItemKind = {
	Text = "  ",
	Method = "  ",
	Function = "  ",
	Constructor = "  ",
	Field = "  ",
	Variable = "  ",
	Class = " ﴯ ",
	Interface = "  ",
	Module = "  ",
	Property = " 襁",
	Unit = "  ",
	Value = "  ",
	Enum = " 練",
	Keyword = "  ",
	Snippet = "  ",
	Color = "  ",
	File = "  ",
	Reference = "  ",
	Folder = "  ",
	EnumMember = "  ",
	Constant = "  ",
	Struct = " פּ ",
	Event = "  ",
	Operator = "  ",
	TypeParameter = "  ",
}

local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("snippy").expand_snippet(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
		style = { border = "string" },
	},
	mapping = {
		["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }), -- mapping mode insert
		["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }), -- mapping mode insert
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<tab>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "snippy" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "nvim_lua" },
		{ name = "nvim_lsp_signature_help" },
	},
	formatting = {
		format = function(entry, vim_item)
			-- fancy icons and a name of kind
			vim_item.kind = CompletionItemKind[vim_item.kind] --.. " " .. vim_item.kind

			-- set a name for each source
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				snippy = "[Snippy]",
				buffer = "[Buffer]",
				path = "[Path]",
				nvim_lua = "[Lua]",
			})[entry.source.name]
			return vim_item
		end,
	},
	sorting = {
		comparators = {
			--require("clangd_extensions.cmp_scores"),
			--cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.kind,
			--cmp.config.compare.length,
			cmp.config.compare.sort_text,
			cmp.config.compare.order,
			--cmp.config.compare.recently_used,
		},
	},
})

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Snippets mapping
vim.cmd([[imap <expr> <Tab> snippy#can_expand_or_advance() ? '<Plug>(snippy-expand-or-next)' : '<Tab>']])
vim.cmd([[imap <expr> <S-Tab> snippy#can_jump(-1) ? '<Plug>(snippy-previous)' : '<Tab>']])
vim.cmd([[smap <expr> <Tab> snippy#can_jump(1) ? '<Plug>(snippy-next)' : '<Tab>']])
vim.cmd([[smap <expr> <S-Tab> snippy#can_jump(-1) ? '<Plug>(snippy-previous)' : '<Tab>']])

-- Completion
vim.api.nvim_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

--------------------------------------------------------------------- LSP GENERAL SETTINGS
-- Highlights
vim.cmd("hi LspDiagnosticsSignError guifg=red")
vim.cmd("hi LspDiagnosticsSignWarning guifg=yellow")
vim.cmd("hi LspDiagnosticsSignHint guifg=cyan")
vim.cmd("hi LspDiagnosticsSignInformation guifg=green")
vim.fn.sign_define(
	"DiagnosticSignError",
	{ text = "", texthl = "LspDiagnosticsSignError", linehl = "", numhl = "LspDiagnosticsSignError" }
)
vim.fn.sign_define(
	"DiagnosticSignWarn",
	{ text = "", texthl = "LspDiagnosticsSignWarning", linehl = "", numhl = "LspDiagnosticsSignWarning" }
)
vim.fn.sign_define(
	"DiagnosticSignHint",
	{ text = "", texthl = "LspDiagnosticsSignHint", linehl = "", numhl = "LspDiagnosticsSignHint" }
)
vim.fn.sign_define(
	"DiagnosticSignInfo",
	{ text = "ℹ", texthl = "LspDiagnosticsSignInformation", linehl = "", numhl = "LspDiagnosticsSignInformation" }
)

-- Mappings.
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
vim.api.nvim_set_keymap("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
vim.api.nvim_set_keymap("x", "ga", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>ga", "<cmd>lua vim.lsp.buf.execute_command()<CR>", opts)
vim.api.nvim_set_keymap("n", "gF", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
vim.api.nvim_set_keymap("n", "gh", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
vim.api.nvim_set_keymap(
	"n",
	"<leader>wl",
	"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
	opts
)
vim.api.nvim_set_keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
vim.api.nvim_set_keymap("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
vim.api.nvim_set_keymap("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)

vim.api.nvim_set_keymap("n", "gs", "<cmd>lua vim.diagnostic.open_float(nil, { source = 'always' })<CR>", opts)
vim.api.nvim_set_keymap("n", "gN", "<cmd>lua vim.diagnostic.goto_prev({ popup_opts = { border = 'single' }})<CR>", opts)
vim.api.nvim_set_keymap("n", "gn", "<cmd>lua vim.diagnostic.goto_next({ popup_opts = { border = 'single' }})<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.set_loclist()<CR>", opts)

-- Mapped with fuzzer
--vim.api.nvim_set_keymap("n", "gy", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
--vim.api.nvim_set_keymap("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", opts)
--vim.api.nvim_set_keymap("n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", opts)
--vim.api.nvim_set_keymap("n", "gic", "<Cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)
--vim.api.nvim_set_keymap("n", "goc", "<Cmd>lua vim.lsp.buf.outgoing_calls()<CR>", opts)
--vim.api.nvim_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
vim.api.nvim_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
vim.api.nvim_set_keymap("v", "ga", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
vim.api.nvim_set_keymap("n", "gw", "<Cmd>lua vim.lsp.buf.workspace_diagnostic()<CR>", opts)
vim.api.nvim_set_keymap("n", "gl", "<cmd>lua vim.lsp.codelens.display()<CR>", opts)
-- Handlers
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "single",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = "single",
})

vim.diagnostic.config({
	underline = true,
	virtual_text = false,
	signs = true,
	update_in_insert = true,
	severity_sort = true,
})

------------------------------------------------------------------------------- LSP-CONFIG
local lspConfig = require("lspconfig")

-- LSP Servers
local on_attach = function(client, bufnr)
	vim.lsp.util.make_position_params(0, client.offset_encoding)
	-- Set autocommands conditional on server_capabilities
	--	if server_capabilities.document_highlight then
	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_set_hl(0, "LspReferenceRead", { italic = true, standout = true, sp = "white" })
		vim.api.nvim_set_hl(0, "LspReferenceText", { italic = true, standout = true, sp = "white" })
		vim.api.nvim_set_hl(0, "LspReferenceWrite", { italic = true, standout = true, sp = "white" })
		vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
		vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
		vim.api.nvim_create_autocmd("CursorHold", {
			callback = vim.lsp.buf.document_highlight,
			buffer = bufnr,
			group = "lsp_document_highlight",
			desc = "Document Highlight",
		})
		vim.api.nvim_create_autocmd("CursorHoldI", {
			callback = vim.lsp.buf.document_highlight,
			buffer = bufnr,
			group = "lsp_document_highlight",
			desc = "Document Highlight",
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			callback = vim.lsp.buf.clear_references,
			buffer = bufnr,
			group = "lsp_document_highlight",
			desc = "Clear All the References",
		})
	end
end

local servers = {
	"rust_analyzer", -- rust
	"bashls", -- bash
	"ts_ls", -- Web Dev (typescript)
	"html", -- Web Dev (html)
	"cssls", -- Web Dev (css)
	"svelte", -- Svelte
	"jsonls", -- JSON
	"yamlls", -- YAML
	"marksman", -- "remark_ls", "grammarly",     -- Txt
	"prosemd_lsp", -- proofreading & lint 4 Markdown
	"lemminx", -- XML
	"pylsp",
	"ruff", -- "jedi_language_server", "pyright", "sourcery", "pylsp",   -- Python
	"dockerls", -- Dockerfile
	"cmake", -- CMake
	"jdtls", -- Java
	"dotls", -- Graphviz
	"volar", -- Web Dev (vue)
	-- "stylelint_lsp", "eslint",
	"kotlin_language_server",
}

for _, lsp in ipairs(servers) do
	lspConfig[lsp].setup({ autostart = true, on_attach = on_attach, capabilities = capabilities })
end

local home_dir = os.getenv("HOME")
lspConfig.clangd.setup({
	autostart = true,
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = {
		"clangd",
		"--enable-config",
		"--clang-tidy",
		"--background-index",
		"--compile-commands-dir=build",
		"--limit-results=0",
		"-j=12",
		"--log=verbose",
		"--query-driver=/usr/bin/**/clang-*,/usr/bin/**/g++-*,"
			.. home_dir
			.. "/ara/eb/adaptivecore/sdk"
			.. "/eblinux/qemu-x86"
			.. "/2.18.0_cmake_update/sysroots/x86_64-pokysdk-linux/usr/bin/x86_64-poky-linux/x86_64-poky-linux-*,",
	},
})

----------------------------------------------------------------------------------- LUA LS
lspConfig.lua_ls.setup({
	autostart = true,
	on_attach = on_attach,
	capabilities = capabilities,
	Lua = {
		runtime = {
			-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
			version = "LuaJIT",
		},
		diagnostics = {
			-- Get the language server to recognize the `vim` global
			globals = { "vim" },
		},
		workspace = {
			-- Make the server aware of Neovim runtime files
			library = vim.api.nvim_get_runtime_file("", true),
			-- Make the server aware of Neovim runtime files
			--library = {
			--    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
			--    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
			--}
		},
		-- Do not send telemetry data containing a randomized but unique identifier
		telemetry = {
			enable = false,
		},
	},
})
