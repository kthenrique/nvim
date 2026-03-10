------------------------------------------------------------------------------------ FTERM
local fterm = require("FTerm")
local shell = os.getenv("SHELL") or "bash"
local termOpts = { noremap = true, silent = true }

local termSetup = {
	cmd = shell,
	border = "double",
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
}

fterm.setup(termSetup)
local terms = {
	a = fterm,
	b = fterm:new(termSetup),
	c = fterm:new(termSetup),
}

local function toggle_shell(id)
	if vim.bo.buftype == "terminal" then
		vim.cmd("stopinsert")
	end
	terms[id]:toggle()
end

for key, _ in pairs(terms) do
	vim.keymap.set({ "n", "t" }, "<A-" .. key .. ">", function()
		toggle_shell(key)
	end, termOpts)
end
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
