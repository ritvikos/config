local wezterm = require 'wezterm'
local config = wezterm.config_builder()
config.color_scheme = 'Batman'
config.enable_scroll_bar = true
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 11.0
config.window_background_opacity = 1.0
config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = "Catppuccin Mocha"

return config
