-- For auto completion
vim.opt.shortmess:append({ c = true })
vim.opt.completeopt = "menuone,noinsert,noselect"

-- Don't put message to show the mode
vim.opt.showmode = false

-- wrap over words
vim.opt.linebreak = true

-- Don't add EOF at the end of file when it is missing
vim.opt.fixendofline = false

-- Disallow hidden buffers
vim.opt.hidden = false

-- Order the new splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Use always clipboard
vim.opt.clipboard = "unnamedplus"

-- Always show tab line
vim.opt.showtabline = 2

-- Show line numbers
vim.opt.number = true

-- Make latex the standard tex
vim.g.tex_flavor = "latex"

-- ignore case in search and replace
vim.opt.ignorecase = true

-- don't ignore case if Upper Case letters appear in search
vim.opt.smartcase = true

-- set the highlight for line number
vim.opt.cul = true

-- minimal nr of coloumns for the line number
vim.opt.numberwidth = 2

-- enable mouse support for normal mode
-- useful for dap-ui repl
vim.opt.mouse = "nv"

-- always show the signcolumn
vim.opt.signcolumn = "yes"

-- enable true colors support
vim.opt.termguicolors = true

-- update interval for gitsigns
vim.opt.updatetime = 500

-- Folding
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 0
vim.opt.foldenable = false

-- Indentation
vim.opt.cc = "+1"
vim.opt.textwidth = 100
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- File patterns to ignore while expanding
vim.opt.wildignore = "*.a,*.o,*.elf,*.out,*.bin,*.pdf,*.swp,*.tmp,*.directory"

-- Local scripts
vim.opt.exrc = true
vim.opt.secure = true

-- Sessions
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
