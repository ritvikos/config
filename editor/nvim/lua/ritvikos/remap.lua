vim.g.mapleader = " "
vim.keymap.set({ "n", "v" }, "j", "h")
vim.keymap.set({ "n", "v" }, "k", "k")
vim.keymap.set({ "n", "v" }, "l", "j")
vim.keymap.set({ "n", "v" }, ";", "l")

vim.keymap.set("n", "jk", "i")
vim.keymap.set("i", "jk", "<Esc>")

-- Copy/Paste
vim.keymap.set("n", "<leader>v", '"+p')
vim.keymap.set("i", "<C-v>", "<C-r>+")

-- Window Splits
vim.keymap.set("n", "<M-v>", ":vsp<CR>")
vim.keymap.set("n", "<M-h>", ":sp<CR>")

vim.keymap.set("n", "<M-j>", "<C-w>h")
vim.keymap.set("n", "<M-k>", "<C-w>k")
vim.keymap.set("n", "<M-l>", "<C-w>j")
vim.keymap.set("n", "<M-;>", "<C-w>l")
