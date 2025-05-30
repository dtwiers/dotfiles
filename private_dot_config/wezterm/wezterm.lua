local wezterm = require 'wezterm'

local dimmer = { brightness = 0.18 }
local backgroundPlain = {
    source = {
        Color = 'black',
    },
    height = "100%",
    width = "100%",
    hsb = dimmer,
    attachment = "Fixed",
    opacity = 0.95,
}

local background = backgroundPlain

local getBackground = function()
    return { background }
end

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
config.font = wezterm.font('VictorMono Nerd Font', { weight = 'Light', stretch = 'Normal', style = 'Normal' })
config.line_height = 0.92
config.font_size = 16
config.scrollback_lines = 80000
config.native_macos_fullscreen_mode = true
config.animation_fps = 60
config.background = getBackground()
config.cursor_blink_ease_in = "Linear"
config.cursor_blink_ease_out = "Linear"
config.cursor_blink_rate = 500
config.color_scheme = 'Dissonance (Gogh)'

config.inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.5,

}
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0
}
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.default_cursor_style = "BlinkingBlock"
config.tab_max_width = 64

config.colors = {
    tab_bar = {
        background = "#0e1013",
        new_tab = {
            bg_color = "#0e1013",
            fg_color = "#039660",
            intensity = "Bold",
        },
    },
}

wezterm.on(
    'format-tab-title',
    function(tab, tabs, panes, config, hover, max_width)
        return require("tabs").format_tab(tab, tabs, panes, config, hover, max_width)
    end
)

wezterm.on(
    'update-status',
    function(window, pane)
        local text = " " .. wezterm.nerdfonts.md_calendar .. " " .. wezterm.strftime("%a %Y-%m-%d")
        text = text .. " " .. wezterm.nerdfonts.md_clock .. " " .. wezterm.strftime("%H:%M:%S (%Z)")
        window:set_right_status(wezterm.format({
            { Background = { Color = "#0e1013" } },
            { Foreground = { Color = "#B39DF3" } },
            { Text = text },
        }))
    end
)


return config
