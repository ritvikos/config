return {
  "neovim/nvim-lspconfig",
  dependencies = { "saghen/blink.cmp" },
  lazy = false,

  config = function()
    local has_blink, blink = pcall(require, "blink.cmp")
    local capabilities = has_blink and blink.get_lsp_capabilities() or {}

    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    vim.lsp.enable({
      "clangd",
      "gopls",
      "rust_analyzer",
      "lua_ls",
      "marksman",
      "ty",
      "taplo",
    })
  end,
}
