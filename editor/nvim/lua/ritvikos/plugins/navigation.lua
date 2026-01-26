return {
  -- Fuzzy Finder
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    opts = {
      debug = { -- While it's in beta
        enabled = true,
      },
    },
    lazy = false, -- Plugin inits lazily already
    keys = {
      {
        "ff",
        function()
          require("fff").find_files()
        end,
        desc = "FFFind files",
      },
    },
  },

  -- FS Tree
  {
    "mikavilpas/yazi.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      {
        "<leader>F",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        "<M-f>",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },

    -- yazi config
    opts = {
      open_for_directories = true,
      keymaps = {
        show_help = "<f1>",
      },
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
  },
}
