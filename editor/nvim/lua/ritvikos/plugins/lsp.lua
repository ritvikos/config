return {
  "neovim/nvim-lspconfig",
  dependencies = { "saghen/blink.cmp" },
  opts = {
    servers = {
      clangd = {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=never",
          "-j=4",
        },
        root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
      },
      gopls = {
        settings = { gopls = { gofumpt = true } },
        root_markers = { "go.mod", ".git" },
      },
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            linkedProjects = { "rust-project.json" },
            checkOnSave = false,
            procMacro = { enable = true },
          },
        },
        root_markers = { "rust-project.json", "Cargo.toml", ".git" },
      },
      lua_ls = {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      },
    },
  },

  config = function(_, opts)
    local blink = require("blink.cmp")
    local capabilities = blink.get_lsp_capabilities()

    for server, config in pairs(opts.servers) do
      config.capabilities = vim.tbl_deep_extend("force", capabilities, config.capabilities or {})
      vim.lsp.config(server, config)
      vim.lsp.enable(server)
    end
  end,
}
