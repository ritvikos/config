return {
  {
    "terrastruct/d2-vim",
    version = "*",
    ft = { "d2" },
    config = function()
      vim.g.d2_fmt_autosave = 1
    end,
  },
}
