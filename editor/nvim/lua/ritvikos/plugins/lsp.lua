return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp",
  },
  config = function()
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    local servers = {
      "rust_analyzer",
      "lua_ls",
      "ruff",
      "gopls",
    }
    for _, server in ipairs(servers) do
      vim.lsp.config(server, {
        capabilities = capabilities,
        settings = server == "lua_ls" and {
          Lua = {
            diagnostics = {
              globals = {
                "vim",
              },
            },
          },
        } or {},
      })
      vim.lsp.enable(server)
    end
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local opts = {
          buffer = args.buf,
        }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      end,
    })
  end,
}
