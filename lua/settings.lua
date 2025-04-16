---------------------------------------------------------------------------------- GENERAL
-- highlight on yank
vim.cmd([[au TextYankPost * lua vim.highlight.on_yank({higroup="IncSearch",timeout=300,on_visual=true})]])
