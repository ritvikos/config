return {
  {
    "tpope/vim-sleuth",
  },
  {
    "echasnovski/mini.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("mini.surround").setup({
        mappings = {
          add = "sa",
          delete = "sd",
          find = "sf",
          find_left = "sF",
          highlight = "sh",
          replace = "sr",
        },
      })
      require("mini.pairs").setup({
        modes = {
          insert = true,
          command = false,
          terminal = false,
        },
        mappings = {
          ["("] = {
            action = "open",
            pair = "()",
            neigh_pattern = "^[^\\]",
          },
          ["["] = {
            action = "open",
            pair = "[]",
            neigh_pattern = "^[^\\]",
          },
          ["{"] = {
            action = "open",
            pair = "{}",
            neigh_pattern = "^[^\\]",
          },
          [")"] = {
            action = "close",
            pair = "()",
            neigh_pattern = "^[^\\]",
          },
          ["]"] = {
            action = "close",
            pair = "[]",
            neigh_pattern = "^[^\\]",
          },
          ["}"] = {
            action = "close",
            pair = "{}",
            neigh_pattern = "^[^\\]",
          },
          ['"'] = {
            action = "closeopen",
            pair = '""',
            neigh_pattern = "^[^\\]",
            register = {
              cr = false,
            },
          },
          ["'"] = {
            action = "closeopen",
            pair = "''",
            neigh_pattern = "^[^%a\\]",
            register = {
              cr = false,
            },
          },
          ["`"] = {
            action = "closeopen",
            pair = "``",
            neigh_pattern = "^[^\\]",
            register = {
              cr = false,
            },
          },
        },
      })
    end,
  },
  {
    -- Sidebar with a tree-like outline of symbols code, powered by LSP.
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    config = function()
      require("outline").setup({})
    end,
  },
  {
    -- Theme
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({})
      vim.cmd("colorscheme github_dark_tritanopia")
    end,
  },
}
