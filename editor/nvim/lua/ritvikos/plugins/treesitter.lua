return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      require("nvim-treesitter").install({
        "lua",
        "rust",
        "go",
        "json",
        "python",
        "markdown",
      })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          if pcall(vim.treesitter.get_parser, 0, vim.bo.filetype) then
            vim.treesitter.start()
          end
        end,
      })
    end,
  },
}
