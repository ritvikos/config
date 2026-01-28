-- File Ops
vim.keymap.set("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })

-- Movements
vim.keymap.set({ "n", "v" }, "j", "h", { desc = "Move cursor left" })
vim.keymap.set({ "n", "v" }, "k", "k", { desc = "Move cursor up" })
vim.keymap.set({ "n", "v" }, "l", "j", { desc = "Move cursor down" })
vim.keymap.set({ "n", "v" }, ";", "l", { desc = "Move cursor right" })

-- Modes
vim.keymap.set("n", "jk", "i", { desc = "Enter Insert mode" })
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit Insert mode to Normal mode" })

-- Clipboard
vim.keymap.set("n", "<leader>v", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set("i", "<C-v>", "<C-r>+", { desc = "Paste from system clipboard in Insert mode" })

-- Window
vim.keymap.set("n", "<M-v>", ":vsp<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<M-h>", ":sp<CR>", { desc = "Split window horizontally" })

vim.keymap.set("n", "<M-j>", "<C-w>h", { desc = "Focus window to the left" })
vim.keymap.set("n", "<M-k>", "<C-w>k", { desc = "Focus window above" })
vim.keymap.set("n", "<M-l>", "<C-w>j", { desc = "Focus window below" })
vim.keymap.set("n", "<M-;>", "<C-w>l", { desc = "Focus window to the right" })

-- Goto
vim.keymap.set({ "n", "v" }, "ge", "G$", { desc = "Go to EOF" })
vim.keymap.set({ "n", "v" }, "gg", "gg0", { desc = "Go to start of file" })
vim.keymap.set({ "n", "v" }, "gl", "$", { desc = "Go to end of line" })
vim.keymap.set({ "n", "v" }, "gs", "0", { desc = "Go to start of line" })
vim.keymap.set({ "n", "v" }, "<leader>e", "<cmd>Oil<cr>", { desc = "Show FS Tree" })
vim.keymap.set("n", "<M-o>", "<C-o>", { desc = "Jump backward in jump list" })
vim.keymap.set("n", "<M-i>", "<C-i>", { desc = "Jump forward in jump list" })

-- Selection
vim.keymap.set("n", ">", ">>", { desc = "Indent line right" })
vim.keymap.set("n", "<", "<<", { desc = "Indent line left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent selection right" })
vim.keymap.set("v", "<", "<gv", { desc = "Indent selection left" })

-- -- Helpers
local function select_to(motion)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd("normal! V" .. motion .. "o")
  pcall(vim.api.nvim_win_set_cursor, 0, cursor_pos)
end

vim.keymap.set({ "n", "v" }, "<M-a>", "ggVG", { desc = "Select all" })

vim.keymap.set({ "n", "v" }, "<M-p>", function()
  select_to("gg")
end, { desc = "Select to top (preserve cursor)" })

vim.keymap.set({ "n", "v" }, "<M-n>", function()
  select_to("G")
end, { desc = "Select to bottom (preserve cursor)" })
