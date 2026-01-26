return {
  "stevearc/conform.nvim",
  version = "*",
  opts = {
    formatters_by_ft = {
      lua = {
        "stylua",
      },
      python = {
        "ruff",
      },
      rust = {
        "rustfmt",
        lsp_format = "fallback",
      },
      go = {
        "gofmt",
      },
    },
  },
}
