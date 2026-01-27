return {
  "neovim/nvim-lspconfig",
  dependencies = { "saghen/blink.cmp" },
  opts = {
    servers = {
      rust_analyzer = {},
      ruff = {},
      gopls = {
        settings = {
          gopls = { gofumpt = true },
        },
      },
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      },
    },
  },

  config = function(_, opts)
    local blink = require("blink.cmp")
    local capabilities = blink.get_lsp_capabilities()

    -- Setup servers
    for server, config in pairs(opts.servers) do
      config.capabilities = vim.tbl_deep_extend("force", capabilities, config.capabilities or {})
      vim.lsp.config(server, config)
      vim.lsp.enable(server)
    end

    -- Keymaps on Attach
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = "LSP: " .. desc })
        end

        map("n", "gd", vim.lsp.buf.definition, "Definition")
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
      end,
    })
  end,
}
