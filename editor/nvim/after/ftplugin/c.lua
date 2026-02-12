vim.opt_local.expandtab = false
vim.opt_local.shiftwidth = 8
vim.opt_local.tabstop = 8

-- Let 'clangd' handle formatting, instead of 'conform'
vim.b.conform_format_on_save = false

local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP: Hover (Expand Macro)" })

vim.keymap.set(
  "n",
  "<leader>gh",
  "<cmd>ClangdSwitchSourceHeader<cr>",
  { buffer = bufnr, desc = "LSP: [G]oto [H]eader/Source" }
)
