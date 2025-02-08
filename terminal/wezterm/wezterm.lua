local wezterm = require "wezterm"

local config = wezterm.config_builder()
config.check_for_updates = false
config.color_scheme = "Equilibrium Dark (base16)"
config.enable_scroll_bar = true
config.font = wezterm.font "JetBrains Mono"
config.font_size = 11.0
config.window_background_opacity = 1.0
config.hide_tab_bar_if_only_one_tab = true
config.front_end = "WebGpu"
config.default_cwd = "C:/Users/ritvi/Desktop"

config.window_decorations = "TITLE | RESIZE"
config.window_padding = {
    left = 10,
    right = 10,
    top = 0,
    bottom = 0
}

local act = wezterm.action
config.keys = {
    {
        key = "v",
        mods = "CTRL|ALT",
        action = wezterm.action.SplitVertical {domain = "CurrentPaneDomain"}
    },
    {
        key = "h",
        mods = "CTRL|ALT",
        action = wezterm.action.SplitHorizontal {domain = "CurrentPaneDomain"}
    },
    {
        key = ";",
        mods = "ALT",
        action = act.ActivatePaneDirection "Right"
    },
    {
        key = "j",
        mods = "ALT",
        action = act.ActivatePaneDirection "Left"
    },
    {
        key = "k",
        mods = "ALT",
        action = act.ActivatePaneDirection "Up"
    },
    {
        key = "l",
        mods = "ALT",
        action = act.ActivatePaneDirection "Down"
    }
}

return config
