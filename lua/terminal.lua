------------------------------------------------------------------------------------ FTERM
local fterm = require("FTerm")
fterm.setup({
	cmd = function()
		local sh = os.getenv("SHELL")
		if sh == nil or sh == "" then
			sh = "/bin/bash"
		end
		return sh
	end,
	-- Neovim's native window border. See `:h nvim_open_win` for more configuration options.
	border = "double",
	-- Close the terminal as soon as shell/command exits.
	-- Disabling this will mimic the native terminal behaviour.
	auto_close = true,
	-- Highlight group for the terminal. See `:h winhl`
	hl = "Normal",
	-- Transparency of the floating window. See `:h winblend`
	blend = 20,
	-- Object containing the terminal window dimensions.
	-- The value for each field should be between `0` and `1`
	dimensions = {
		height = 0.9, -- Height of the terminal window
		width = 0.95, -- Width of the terminal window
		x = 0.5, -- X axis of the terminal window
		y = 0.5, -- Y axis of the terminal window
	},
	-- Callback invoked when the terminal exits.
	-- See `:h jobstart-options`
	on_exit = nil,
	-- Callback invoked when the terminal emits stdout data.
	-- See `:h jobstart-options`
	on_stdout = nil,
	-- Callback invoked when the terminal emits stderr data.
	-- See `:h jobstart-options`
	on_stderr = nil,
})

vim.cmd('command! FTermOpen lua require("FTerm").open()')
-- This will close the terminal window but preserves the actual terminal session
vim.cmd('command! FTermClose lua require("FTerm").close()')
-- Unlike closing, this will remove the terminal session
vim.cmd('command! FTermExit lua require("FTerm").exit()')
-- Toggling the terminal
vim.cmd('command! FTermToggle lua require("FTerm").toggle()')

vim.api.nvim_set_keymap(
	"n",
	"<C-b>",
	'<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"t",
	"<C-b>",
	'<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>',
	{ noremap = true, silent = true }
)

local admin_term = fterm:new({
	ft = "fterm_shell",
	cmd = os.getenv("SHELL"),
	blend = 10,
	dimensions = {
		height = 0.9,
		width = 0.95,
	},
})

-- Use this to toggle btop in a floating terminal
function fterm_shell_toggle()
	admin_term:toggle()
end

vim.cmd("command! FTermShell lua fterm_shell_toggle()")
vim.api.nvim_set_keymap("n", "<C-n>", "<C-\\><C-n><CMD>FTermShell<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<C-n>", "<C-\\><C-n><CMD>FTermShell<CR>", { noremap = true, silent = true })

----------------------------------------------------------------------------------- GOMOVE
require("gomove").setup({
	-- whether or not to map default key bindings, (true/false)
	map_defaults = true,
	-- what method to use for reindenting, ("vim-move" / "simple" / ("none"/nil))
	reindent_mode = "vim-move",
	-- whether to not to move past line when moving blocks horizontally, (true/false)
	move_past_line = true,
	-- Whether or not to move past line when moving horizontally
	move_past_end_col = true,
	-- whether or not to ignore indent when duplicating lines horizontally, (true/false)
	ignore_indent_lh_dup = true,
})
