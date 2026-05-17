return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "n",
      desc = "Format buffer",
    },
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "v",
      desc = "Format range",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
      go = { "gofumpt", "goimports-reviser" },
      rust = { "rustfmt" },
    },
    format_on_save = {
      timeout_ms = 1500,
      lsp_fallback = true,
    },
  },
}
