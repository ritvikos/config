-- Install Tree-sitter-cli: `cargo install --locked tree-sitter-cli`
-- TSInstall <lang>

return {
  {
    "nvim-treesitter/nvim-treesitter",
    ensure_installed = { "go", "rust", "c", "python", "bash", "markdown", "json", "toml" },
    build = ":TSUpdate",
    opts = {
      auto_install = true,
      highlight = {
        enable = true,
      },
    },
  },
}
