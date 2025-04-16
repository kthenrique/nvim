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

vim.cmd('command! OpenAraDesignDocPdf silent exec "!xdg-open build/doc/project/design_coat/ac_com_design_document.pdf"')
vim.cmd('command! OpenAraBullseyeCoverage silent exec "!xdg-open build/BullseyeCoverage.html"')
vim.cmd('command! OpenAraReqM2Report silent exec "!xdg-open build/RequirementTracing.html"')

function CompleteTargets(ArgLead, CmdLine, CursorPos)
	local targets =
		vim.fn.systemlist('ninja -C build -t targets all | sed "s/: .*$//" | grep -v "cmake|txt|/" | sort | uniq ')
	local build_types = { "Debug", "fsanitizethread", "Release", "Bullseye", "Coverage", "RelWithDebInfo" }
	local target_os = { "Custom", "EBLinux", "Host", "QNX" }
	local argList = {}
	for str in string.gmatch(CmdLine, "([^%s]+)") do
		table.insert(argList, str)
	end

	local filter = function(t)
		local matches = {}
		for _, str in ipairs(t) do
			if string.find(str, ArgLead, 0, string.len(ArgLead)) then
				table.insert(matches, str)
			end
		end
		return matches
	end
	if #argList == 1 or (#argList == 2 and string.sub(CmdLine, -1) ~= " ") then
		return filter(targets)
	elseif #argList == 2 or (#argList == 3 and string.sub(CmdLine, -1) ~= " ") then
		return filter(build_types)
	else
		return filter(target_os)
	end
end

function BuildTarget(cmd, opt)
	local options = opt.fargs
	local target = options[1] or " "
	local build_type = options[2] or "Debug"
	local target_os = options[3] or "Host"
	require("FTerm").run(
		"branch=${PWD##*/}; cd .. && bash ara_Chores/chores.sh "
			.. cmd
			.. " $branch "
			.. target
			.. " "
			.. build_type
			.. " "
			.. target_os
			.. "; cd -"
	)
end

vim.api.nvim_create_user_command("BuildAraTarget", function(opts)
	BuildTarget("b", opts)
end, { nargs = "+", complete = CompleteTargets })
vim.api.nvim_create_user_command("BuildAraBullseyeCoverage", function(opts)
	BuildTarget("c", opts)
end, { nargs = "+", complete = CompleteTargets })
vim.api.nvim_create_user_command("BuildAraRequirements", function(opts)
	BuildTarget("r", opts)
end, { nargs = "*", complete = CompleteTargets })
vim.cmd(
	'command! BuildAraDesignPdf lua require("FTerm").run("branch=${PWD##*/}; cd build && ninja ac_com_design_document_pdf; cd -")'
)

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
vim.api.nvim_set_keymap("n", "<C-z>", "<C-\\><C-n><CMD>FTermShell<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<C-z>", "<C-\\><C-n><CMD>FTermShell<CR>", { noremap = true, silent = true })

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
