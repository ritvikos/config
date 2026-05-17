vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.expandtab = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus" -- xclip/wl-clipboard
vim.opt.timeoutlen = 200
vim.opt.updatetime = 250
vim.opt.virtualedit = "onemore"
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
vim.opt.foldlevel = 200
vim.opt.foldlevelstart = 200
vim.opt.lazyredraw = true
vim.opt.scrolljump = 5
vim.opt.laststatus = 3
vim.opt.cmdheight = 0
vim.opt.shortmess:append("Ic")

vim.opt.whichwrap:append("<,>,h,l,[,]")
vim.opt.backspace = "indent,eol,start"
vim.opt.background = "dark"

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = ">-> "

vim.lsp.inlay_hint.enable(true)
