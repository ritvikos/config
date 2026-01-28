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
          add = "ms",
          delete = "md",
          replace = "mr",
          find = "mf",
          find_left = "mF",
          highligh = "mh",
          update_n_lines = "mn",
        },
      })
      require("mini.indentscope").setup({
        draw = {
          delay = 0,
          animation = require("mini.indentscope").gen_animation.none(),
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

  -- Flash enhances the built-in search functionality by showing labels
  -- at the end of each match, letting you quickly jump to a specific
  -- location.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      -- Simulate nvim-treesitter incremental selection
      { "<c-space>", mode = { "n", "o", "x" },
        function()
          require("flash").treesitter({
            actions = {
              ["<c-space>"] = "next",
              ["<BS>"] = "prev"
            }
          })
        end, desc = "Treesitter Incremental Selection" },
    },
  },

  -- Sidebar with a tree-like outline of symbols code, powered by LSP.
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle Outline" },
    },
    opts = {
      outline_window = {
        auto_jump = false,
        center_on_jump = true,
        width = 30,
      },
      outline_items = {
        show_symbol_details = true,
        show_symbol_lineno = true,
        highlight_hovered_item = true,
      },
      symbol_folding = {
        autofold_depth = 1,
        auto_unfold = { hovered = true },
      },
      preview_window = {
        auto_preview = false,
        border = "rounded",
        width = 50,
        live = false,
      },
      keymaps = {
        up_and_jump = "k",
        down_and_jump = "l",
      },
      symbols = {
        icon_fetcher = function(kind, _, symbol)
          local icon_map = {
            public = "○",
            protected = "◉",
            private = "●",
          }
          local icon = require("outline.config").o.symbols.icons[kind].icon -- fallback
          if symbol and symbol.access then
            return icon .. " " .. (icon_map[symbol.access] or "")
          end
          return icon
        end,
      },
    },
  },

  -- A pretty list for showing diagnostics, references, telescope results, quickfix and
  -- location lists to help you solve all the trouble your code is causing.
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {
      auto_close = false,
      auto_open = false,
      restore = true,
      follow = true,
      indent_guides = true,
      max_items = 200,
      multiline = true,
      icons = {
        indent = {
          top = "",
          middle = "",
          last = "",
          fold_open = "",
          fold_closed = "",
          ws = "",
        },
      },
      modes = {
        -- Diagnostics at project-level
        diagnostics_global = {
          mode = "diagnostics",
          win = {
            type = "split",
            relative = "editor",
            position = "right",
            size = 85,
            wo = {
              wrap = true,
              linebreak = true,
              breakindent = true,
              breakindentopt = "shift:11",
            },
          },
          groups = {
            { "filename", format = "{file_icon} {filename}" },
          },
          format = "{severity_icon} {pos} {message}",
          filter = {},
        },
        -- Diagnostics at file-level (opened file)
        diagnostics_local = {
          mode = "diagnostics",
          win = {
            position = "bottom",
            height = 10,
            wo = {
              wrap = true,
              linebreak = true,
            },
          },
          filter = { buf = 0 },
          format = "{severity_icon} {pos} {message}",
          groups = {
            { "filename", format = "{file_icon} {filename}" },
          },
        },
      },
    },
    keys = {
      {
        "<leader>dg",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Project Diagnostics (Trouble)",
      },
      {
        "<leader>dl",
        "<cmd>Trouble diagnostics_buffer toggle<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
    },
  },

  -- Inline diagnostic messages
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup({
        options = {
          multilines = {
            enabled = true,
            always_show = true,
            trim_whitespaces = true,
          },
          use_icons_from_diagnostic = true,
        },
      })
      vim.diagnostic.config({ virtual_text = false })
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          -- LEFT
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = { { "filename", file_status = true, path = 1 } },
          lualine_x = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
            },
          },
          lualine_y = { "encoding", "filetype" },
          lualine_z = { "location", "progress" },
        },
      })
    end,
  },

  -- Hints
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 0,
      icons = {
        mappings = false,
        keys = {
          Alt = "M-",
          Control = "C-",
          Shift = "S-",
        },
      },
      win = {
        border = "rounded",
        padding = { 1, 2 },
      },
      spec = {
        -- Core Groups
        { "<leader>f", group = "find/format" },
        { "<leader>h", group = "git-hunk" },
        { "<leader>d", group = "diagnostics" },
        { "g", group = "goto" },
        { "m", group = "match/surround" },

        -- Window Management
        { "<M-;>", desc = "Focus Right" },
        { "<M-h>", desc = "Split Horizontal" },
        { "<M-j>", desc = "Focus Left" },
        { "<M-k>", desc = "Focus Up" },
        { "<M-l>", desc = "Focus Down" },
        { "<M-v>", desc = "Split Vertical" },

        -- Bulk Selection
        { "<M-a>", desc = "Select All" },
        { "<M-n>", desc = "Select to Bottom" },
        { "<M-p>", desc = "Select to Top" },
      },
    },
  },

  -- Theme
  {
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
