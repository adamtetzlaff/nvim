vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- disable netrw per nvim-tree docs
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

opt.nu = true
opt.relativenumber = false
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = false
opt.hlsearch = true
opt.incsearch = true
opt.termguicolors = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.clipboard = "unnamedplus"
opt.updatetime = 250
opt.timeoutlen = 300
opt.completeopt = "menuone,noselect"
opt.cursorline = true
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"
opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.undofile = true
opt.backspace = "indent,eol,start"
