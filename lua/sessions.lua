--------------------------------------------------------------------------------- STARTIFY
vim.g.startify_custom_header = {
	"     ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
	"     ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
	"     ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
	"     ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
	"     ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
	"     ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
}
vim.g.startify_custom_footer = "startify#pad(startify#fortune#boxed())"

vim.g.startify_lists = {
	{ type = "files", header = { "   MRU" } },
	{ type = "sessions", header = { "   Sessions" } },
	{ type = "bookmarks", header = { "   Bookmarks" } },
	{ type = "commands", header = { "   Commands" } },
}

vim.cmd([[
function DeleteHiddenAndEmptyBuffers() " Vim with the 'hidden' option
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bwipeout' buf
    endfor
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && bufname(v:val)==""')
        silent execute 'bwipeout' buf
    endfor
endfunction
command! DeleteHiddenAndEmptyBuffers call DeleteHiddenAndEmptyBuffers()
]])

vim.cmd("autocmd BufWrite  * silent! DeleteHiddenAndEmptyBuffers")

-- SESSIONS
vim.g.startify_session_autoload = 1
vim.g.startify_session_before_save = {
	":tabdo NvimTreeClose",
	":tabdo DiffviewClose",
	":silent! DeleteHiddenAndEmptyBuffers",
	":tabfirst",
}
vim.g.startify_session_delete_buffers = 1 -- Let Startify take care of buffers
--vim.g.startify_session_dir = vim.fn.stdpath("data") .. "/session/"
vim.g.startify_session_number = 50
vim.g.startify_session_persistence = 1 -- Automatically update sessions
vim.g.startify_session_remove_lines = { "NvimTree" }
vim.g.startify_session_savecmds = { ":silent! DeleteHiddenAndEmptyBuffers" }
--vim.g.startify_session_savevars =
vim.g.startify_session_sort = 0 -- Sort sessions by modification time

-- Get rid of empy buffer and quit
vim.g.startify_enable_special = 0
vim.g.startify_fortune_use_unicode = 1

vim.g.startify_files_number = 5
