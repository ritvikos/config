return {
  -- Fuzzy Finder
  {
    "ibhagwan/fzf-lua",

    --stylua: ignore
    keys = {
      { "ff", function() require("fzf-lua").files() end, desc = "Find Files" },
      { "<leader>fb", function() require("fzf-lua").buffers() end, desc = "Buffers" },
      { "<leader>fo", function() require("fzf-lua").oldfiles() end, desc = "Old Files" },
      { "<leader>fg", function() require("fzf-lua").live_grep() end, desc = "Live Grep (Project)" },
      { "<leader>fw", function() require("fzf-lua").grep_cword() end, desc = "Grep Word" },
      { "<leader>fr", function() require("fzf-lua").resume() end, desc = "Resume Last Search" },
    },

    opts = function()
      return {
        "default-title",
        winopts = {
          height = 0.85,
          width = 0.80,
          preview = {
            layout = "flex",
            scrollbar = "float",
          },
        },
        files = {
          formatter = "path.filename_first",
          git_icons = false,
        },
        grep = {
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
        },
      }
    end,
    config = function(_, opts)
      require("fzf-lua").setup(opts)
      require("fzf-lua").register_ui_select()
    end,
  },

  -- FS Tree
  {
    "stevearc/oil.nvim",
    lazy = false,
    cmd = "Oil",
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
      { "<leader>-", "<cmd>Oil --float<cr>", desc = "Open Oil in floating window" },
    },
    opts = {
      default_file_explorer = true,
      delete_to_trash = true,
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          return name == ".." or name == ".git"
        end,
      },

      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        [";"] = "actions.select",
        ["j"] = "actions.parent",
        ["<M-p>"] = "actions.preview",
        ["<M-c>"] = "actions.close",
        ["g."] = "actions.toggle_hidden",
        ["_"] = "actions.open_cwd",
      },

      float = {
        padding = 2,
        max_width = 0.8,
        max_height = 0.8,
        border = "rounded",
      },

      preview_win = {
        update_on_cursor_moved = false,
        preview_method = "scratch",
      },
    },
  },
}
