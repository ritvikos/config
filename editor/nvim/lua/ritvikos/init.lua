if vim.loader then
  vim.loader.enable()
end

require("ritvikos.config.options")
require("ritvikos.config.keymaps")
require("ritvikos.config.lazy")
require("ritvikos.config.autocmds")
