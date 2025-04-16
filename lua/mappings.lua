local map = vim.api.nvim_set_keymap

local options = { noremap = true }

vim.cmd('let mapleader = ""')

-- folding with space bar
map("n", "<space>", "za", options)

-- browsing splits
map("n", "<c-j>", "<c-w>j", options)
map("n", "<c-k>", "<c-w>k", options)
map("n", "<c-h>", "<c-w>h", options)
map("n", "<c-l>", "<c-w>l", options)

-- Terminal browsing
map("t", "<c-h>", "<C-w>h", options)
map("t", "<c-j>", "<C-w>j", options)
map("t", "<c-k>", "<C-w>k", options)
map("t", "<c-l>", "<C-w>l", options)
map("i", "<c-h>", "<C-w>h", options)
map("i", "<c-j>", "<C-w>j", options)
map("i", "<c-k>", "<C-w>k", options)
map("i", "<c-l>", "<C-w>l", options)
map("n", "<c-h>", "<C-w>h", options)
map("n", "<c-j>", "<C-w>j", options)
map("n", "<c-k>", "<C-w>k", options)
map("n", "<c-l>", "<C-w>l", options)
--function _G.set_terminal_keymaps()
--	local opts = { buffer = 0 }
--	vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
--	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
--	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
--	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
--	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
--	vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
--end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
--vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- Terminal Utils
vim.api.nvim_create_user_command("ST", function()
	vim.cmd("bel terminal")
	vim.cmd("res 10")
end, {})
vim.api.nvim_create_user_command("VT", function()
	vim.cmd("vert terminal")
end, {})
vim.api.nvim_create_user_command("TT", function()
	vim.cmd("tab terminal")
end, {})

-- Toggle Wrapping
map("n", "<F4>", "<Cmd>set wrap!<CR>", options)

-- Zooming
map("", "zi", [[ <Cmd> resize 900<CR>:vertical resize 900<CR>]], options)
map("", "zo", "<C-w>=", options)

-- Escape
map("i", ";;", "<Esc>", options)
map("", ";;", "<Esc>", options)
map("c", ";;", "<Esc>", options)
map("t", ";;;", "<Esc><C-\\><C-n>", options)

-- Switching tabs
map("", "<A-1>", "1gt", options)
map("", "<A-2>", "2gt", options)
map("", "<A-3>", "3gt", options)
map("", "<A-4>", "4gt", options)
map("", "<A-5>", "5gt", options)
map("", "<A-6>", "6gt", options)
map("", "<A-7>", "7gt", options)
map("", "<A-8>", "8gt", options)
map("", "<A-9>", "9gt", options)
map("", "<A-0>", ":tabp<CR>", options)
map("", "<A-->", ":tabn<CR>", options)

--removing a buffer
map("n", "<A-x>", "<Cmd>bdelete<CR>", options)

-- Ctrl-S Saves changes
map("i", "<C-S>", "<C-O><Cmd>update<CR>", { silent = true })
map("", "<C-S>", "<Esc><Cmd>update<CR>", { silent = true })
map("c", "<C-S>", "<Cmd>update<CR>", { silent = true })
