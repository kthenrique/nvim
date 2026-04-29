------------------------------------------------------------------------------------ FTERM
local fterm = require("FTerm")
local shell = os.getenv("SHELL") or "bash"
local termOpts = { noremap = true, silent = true }

local termSetup = {
	cmd = shell,
	border = "double",
	blend = 20,
	dimensions = {
		height = 0.9,
		width = 0.95,
		x = 0.5,
		y = 0.5,
	},
}

fterm.setup(termSetup)
local terms = {
	a = fterm,
	s = fterm:new(termSetup),
	d = fterm:new(termSetup),
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

local opencode = fterm:new({
	cmd = "EDITOR=nvim opencode --port",
	border = "double",
	blend = 20,
	dimensions = {
		height = 0.9,
		width = 0.95,
		x = 0.5,
		y = 0.5,
	},
})

vim.keymap.set({ "n", "t" }, "<leader>ai", function()
	if vim.bo.buftype == "terminal" then
		vim.cmd("stopinsert")
	end
	opencode:toggle()
end, termOpts)
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
