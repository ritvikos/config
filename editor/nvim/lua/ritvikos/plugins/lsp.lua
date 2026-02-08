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

    local servers = {
      "clangd",
      "gopls",
      "rust_analyzer",
      "lua_ls",
      "marksman",
      "ty",
      "taplo",
    }

    for _, server in ipairs(servers) do
      local has_custom, custom_opts = pcall(require, "ritvikos.lsp." .. server)

      if has_custom then
        vim.lsp.config(server, custom_opts)
      end
    end

    vim.lsp.enable(servers)
  end,
}
