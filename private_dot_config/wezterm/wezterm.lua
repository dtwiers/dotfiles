local wezterm = require 'wezterm'

local dimmer = { brightness = 0.18 }
local backgroundPhoenix = {
    source = {
        File = "/Users/derekwiers/Pictures/bg/Apo7X-Super-Phoenix-blur.png",
    },
    hsb = dimmer,
    attachment = "Fixed",
}
local backgroundMars = {
    source = {
        File = "/Users/derekwiers/Pictures/bg/mars_blurred.png",
    },
    hsb = {brightness = 0.04},
    attachment = "Fixed",
}
local backgroundSynthwave = {
    source = {
        File = "/Users/derekwiers/Pictures/bg/synthwave-blur.png",
    },
    hsb = {brightness = 0.030},
    attachment = "Fixed",
}
local backgroundplain = {
    source = {
        Color = 'black',
    },
    height = "100%",
    width = "100%",
    hsb = dimmer,
    attachment = "Fixed",
}

local background = backgroundplain

local getBackground = function ()
    return {background}
end

local scheme = wezterm.get_builtin_color_schemes()['One Dark (Gogh)']
-- scheme.background = "#0e1013"
scheme.background = "#000000"
scheme.foreground = "#acafb4"

local leader = { key = "Enter", mods = "CTRL|SHIFT", timeout_milliseconds = 1000 }
local keys = {
    {
        key = 'LeftArrow',
        mods = 'LEADER',
        action = wezterm.action.ActivateWindowRelative(-1),
    },
    {
        key = 'RightArrow',
        mods = 'LEADER',
        action = wezterm.action.ActivateWindowRelative(1),
    },
    {
        key = 'h',
        mods = 'LEADER',
        action = wezterm.action.ActivateWindowRelative(-1),
    },
    {
        key = 'l',
        mods = 'LEADER',
        action = wezterm.action.ActivateWindowRelative(1),
    },
}
-- for i in 1, 8 do
--     table.insert(keys, {
--         key = tostring(i),
--         mods = 'LEADER',
--         action = wezterm.action.ActivateWindow(i - 1),
--     })
-- end

local config = wezterm.config_builder()
config.leader = leader
config.keys = keys

config.window_background_opacity = 0.92
config.macos_window_background_blur = 40
config.max_fps = 120
config.font = wezterm.font('VictorMono Nerd Font', {weight = 'Medium', stretch = 'Normal', style = 'Normal'})
config.line_height = 0.92
config.font_size = 18
config.scrollback_lines = 20000
config.native_macos_fullscreen_mode = true
config.animation_fps = 60
-- config.background = getBackground()
config.cursor_blink_ease_in = "Linear"
config.cursor_blink_ease_out = "Linear"
config.cursor_blink_rate = 500
-- config.color_scheme = "Royal (Gogh)"
-- config.color_scheme = "Fishbone (terminal.sexy)"
-- config.color_scheme = 'Solarized Dark - Patched'
-- config.color_scheme = 'Orangeish (terminal.sexy)'
config.color_scheme = 'Moonfly (Gogh)'
-- config.color_schemes = {
--     ['One Darker'] = scheme,
-- }
-- config.color_scheme = "One Darker"

config.inactive_pane_hsb = {
    saturation = 0.6,
    brightness = 0.6,

}
config.window_padding = {
left = 0,
right = 0,
top = 0,
bottom = 0
}
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = true
config.default_cursor_style = "BlinkingBlock"

return config
