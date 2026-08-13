--------------------------------------------------------------------------------- GITSIGNS
require("gitsigns").setup({
	numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
	current_line_blame = true,
	current_line_blame_formatter = "<summary> (<author>)[<author_time:%d.%m.%y>]",
	sign_priority = 1,
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		map("n", "[c", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		-- Actions
		map("n", "<leader>hs", gs.stage_hunk, { desc = "stage hunk" })
		map("n", "<leader>hr", gs.reset_hunk, { desc = "reset hunk" })
		map("v", "<leader>hs", function()
			gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "visual stage hunk" })
		map("v", "<leader>hr", function()
			gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "visual reset hunk" })
		map("n", "<leader>hS", gs.stage_buffer, { desc = "stage buffer" })
		map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "undo stage buffer" })
		map("n", "<leader>hR", gs.reset_buffer, { desc = "reset buffer" })
		map("n", "<leader>hp", gs.preview_hunk, { desc = "preview hunk" })
		map("n", "<leader>hB", gs.blame, { desc = "blame buffer" })
		map("n", "<leader>hb", function()
			gs.blame_line({ full = true })
		end, { desc = "blame line" })
		map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "toggle current line blame" })
		map("n", "<leader>hd", gs.diffthis, { desc = "diff this" })
		map("n", "<leader>hD", function()
			gs.diffthis("~")
		end, { desc = "diff this ~" })
		map("n", "<leader>td", gs.toggle_deleted, { desc = "toggle deleted" })

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select hunk" })
	end,
})

vim.cmd("hi GitSignsCurrentLineBlame guifg=azure")

--------------------------------------------------------------------------------- DIFFVIEW
--------------------------------------------------------------------------------- GITGRAPH
require("gitgraph").setup({
	hooks = {
		-- Check diff of a commit
		on_select_commit = function(commit)
			vim.notify("DiffviewOpen " .. commit.hash .. "^!")
			vim.cmd(":DiffviewOpen " .. commit.hash .. "^!")
		end,
		-- Check diff from commit a -> commit b
		on_select_range_commit = function(from, to)
			vim.notify("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
			vim.cmd(":DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
		end,
	},
	symbols = {
		merge_commit = "○",
		commit = "●",
		merge_commit_end = "◉",
		commit_end = "◆",

		-- Advanced symbols
		GVER = "│",
		GHOR = "─",

		GCLD = "╮",
		GCRD = "╭",
		GCLU = "╯",
		GCRU = "╰",

		GLRU = "┴",
		GLRD = "┬",
		GLUD = "┤",
		GRUD = "├",

		GFORKU = "┼",
		GFORKD = "┼",

		GRUDCD = "├",
		GRUDCU = "┡",

		GLUDCD = "┪",
		GLUDCU = "┩",

		GLRDCL = "┬",
		GLRDCR = "┬",

		GLRUCL = "┴",
		GLRUCR = "┴",
	},
})

vim.keymap.set("n", "<leader>hg", function()
	require("gitgraph").draw({}, { all = true, max_count = 5000 })
end, { desc = "Show git graph" })
