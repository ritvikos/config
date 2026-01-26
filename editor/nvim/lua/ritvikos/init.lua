-- GENERAL
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

-- vim.opt.lazyredraw = true
-- vim.g.loaded_matchparen = 1

vim.opt.whichwrap:append("<,>,h,l,[,]")
vim.opt.backspace = "indent,eol,start"

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highligh when yanking text",
  group = vim.api.nvim_create_augroup("Highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- LSP --
vim.lsp.config("*", {
  root_markers = { ".git" },
  capabilities = vim.lsp.protocol.make_client_capabilities(),
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
    end

    map("gd", vim.lsp.buf.definition, "Go to Definition")
    map("gr", vim.lsp.buf.references, "Go to References")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action")

    -- NATIVE COMPLETION
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

require("ritvikos.remap")
require("ritvikos.lazy")
