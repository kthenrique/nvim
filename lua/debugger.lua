--------------------------------------------------------------------------- BUILT-IN DEBUGGER
vim.cmd("packadd termdebug")

-- point to another debugger if needed
--vim.g.termdebugger = "arm-none-eabi-gdb"

vim.g.termdebug_useFloatingHover = 0
-- For a nice split window view
vim.g.termdebug_popup = 1
--vim.g.termdebug_wide = 163

--------------------------------------------------------------------------------------- DAP
local dap, dapui = require("dap"), require("dapui")
vim.fn.sign_define("DapBreakpoint", { text = "🏁", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "👉", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "🏴", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "", linehl = "", numhl = "" })
-- ⭕📍🎯👤🖺🗋📝🏁🚩

-- Keymaps
vim.api.nvim_set_keymap("n", "<F5>", [[<cmd>lua require'dap'.continue()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap(
	"n",
	"<F6>",
	[[<cmd>lua require'dap'.toggle_breakpoint()<CR>]],
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<F7>",
	[[<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>]],
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap("n", "<F8>", [[<cmd>lua require'dap'.step_over()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F9>", [[<cmd>lua require'dap'.step_into()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F10>", [[<cmd>lua require'dap'.step_out()<CR>]], { noremap = true, silent = true })

------------------------------------------------------------------------------------- DAP UI
dapui.setup({
	icons = {
		expanded = "▾",
		collapsed = "▸",
	},
	mappings = {
		-- Use a table to apply multiple mappings
		expand = { "<CR>", "<2-LeftMouse>" },
		open = "o",
		remove = "d",
		edit = "e",
	},
	layouts = {
		{
			elements = {
				-- You can change the order of elements in the sidebar
				"stacks",
				"scopes",
				"breakpoints",
			},
			size = 45,
			position = "left", -- Can be "left" or "right"
		},
		{
			elements = {
				"repl",
				"watches",
			},
			size = 10,
			position = "bottom", -- Can be "bottom" or "top"
		},
	},
	floating = {
		max_height = nil, -- These can be integers or a float between 0 and 1.
		max_width = nil, -- Floats will be treated as percentage of your screen.
	},
})

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

vim.api.nvim_set_keymap("n", "<F11>", [[<cmd>lua require'dapui'.eval()<CR>]], { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<F11>', [[<cmd>lua require'dapui'.float_element()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F12>", [[<cmd>lua require'dapui'.toggle()<CR>]], { noremap = true, silent = true })
---------------------------------------------------------------------------------------- C++
-- CodeLLDB: LLDB
dap.adapters.codelldb = {
	name = "codelldb",
	type = "server",
	port = "${port}",
	executable = {
		command = "codelldb",
		args = { "--port", "${port}" },
	},
}

-- LLDB-DAP: LLDB
dap.adapters.lldb = {
	name = "lldb-dap",
	type = "executable",
	command = "lldb-dap",
}

-- Configuration
dap.configurations.cpp = {
	{
		name = "Launch via LLDB (LLDB-DAP)",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		preRunCommands = "break set -E C++",
		stopOnEntry = false,
		args = function()
			local arguments = vim.fn.input("Args to executable: ", " ", "buffer")
			return { arguments }
		end,
		evaluateForHovers = true,
		-- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
		--
		--    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
		--
		-- Otherwise you might get the following error:
		--
		--    Error on launch: Failed to attach to the target process
		--
		-- But you should be aware of the implications:
		-- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
		runInTerminal = false,
	},
	{
		-- If you get an "Operation not permitted" error using this, try disabling YAMA:
		--  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
		name = "Attach via LLDB (LLDB-DAP)",
		type = "lldb", -- Adjust this to match your adapter name (`dap.adapters.<name>`)
		request = "attach",
		pid = require("dap.utils").pick_process,
		args = function()
			return vim.fn.input("Args to executable: ", " ", "buffer")
		end,
	},
	{
		name = "Launch via LLDB (CodeLLDB)",
		type = "codelldb",
		request = "launch", -- could also attach to a currently running process
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = function()
			return { vim.fn.input("Args to executable: ", " ", "buffer") }
		end,
		runInTerminal = false,
	},
}

-- If you want to use this for rust and c, add something like this:
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

---------------------------------------------------------------------------------- PYTHON3
dap.adapters.python = {
	type = "executable",
	command = "/usr/bin/python3",
	args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
	{
		-- The first three options are required by nvim-dap
		name = "Launch file",
		type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
		request = "launch",

		-- Options below are for debugpy, see
		-- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for
		-- supported options

		program = "${file}", -- This configuration will launch the current file if used.
		pythonPath = function()
			-- debugpy supports launching an application with a different interpreter then
			-- the one used to launch debugpy itself. The code below looks for a `venv` or
			-- `.venv` folder in the current directly and uses the python within. You could
			-- adapt this - to for example use the `VIRTUAL_ENV` environment variable.
			local cwd = vim.fn.getcwd()
			if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
				return cwd .. "/venv/bin/python"
			elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
				return cwd .. "/.venv/bin/python"
			else
				return "/usr/bin/python"
			end
		end,
	},
}
