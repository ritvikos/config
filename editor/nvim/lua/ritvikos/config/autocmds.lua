-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highligh when yanking text",
  group = vim.api.nvim_create_augroup("Highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end

    -- Disable native completion, handled by 'plugins/completion.lua'
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(false, client.id, ev.buf, { autotrigger = true })
    end
    vim.bo[ev.buf].omnifunc = ""

    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
    end

    map("gd", vim.lsp.buf.definition, "Go to Definition")
    map("gr", vim.lsp.buf.references, "Go to References")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
  end,
})
