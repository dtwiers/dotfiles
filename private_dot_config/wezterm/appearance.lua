local wezterm = require 'wezterm'
local utils = require 'utils'
local stdcolors = require 'std-colors'
return function(config)
    -- background
    -- local background = {
    --     source = {
    --         Color = 'black',
    --     },
    --     height = "100%",
    --     width = "100%",
    --     hsb = { brightness = 0.18 },
    --     attachment = "Fixed",
    --     opacity = 0.95,
    -- }

    config.window_background_opacity = 0.92
    config.macos_window_background_blur = 40
    config.max_fps = 120

    -- Font
    if utils.os == 'macos' then
        -- config.font = wezterm.font('VictorMono Nerd Font', { weight = 'DemiBold', stretch = 'Normal', style = 'Normal' })
        config.font = wezterm.font(
            {
                family = 'Monaspace Argon NF',
                weight = 'Light',
                stretch = 'Normal',
                style = 'Normal',
                harfbuzz_features = { 'calt', 'liga', 'dlig', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09', 'ss10' },
            }
        )

        config.font_size = 19.5
    else
        config.font = wezterm.font(
            {
                family = 'Monaspace Argon NF',
                weight = 'Light',
                stretch = 'Normal',
                style = 'Normal',
                harfbuzz_features = { 'calt', 'liga', 'dlig', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09', 'ss10' },
            }
        )
        config.line_height = 1
        config.font_size = 12
    end

    config.animation_fps = 60
    -- config.background = { background }

    -- config.color_scheme = 'Dissonance (Gogh)'
    -- config.color_scheme = 'DotGov'
    -- config.color_scheme = 'Dotshare (terminal.sexy)'
    -- config.color_scheme = 'duckbones'
    -- config.color_scheme = "N0tch2k"
    -- config.color_scheme = 'Galaxy'
    config.color_scheme = 'GruvboxDark'
    config.color_scheme = 'Catppuccin Mocha'
    config.color_scheme = 'Ayu Mirage (Gogh)'
    config.color_scheme = 'ayu'

    -- Cursor
    config.default_cursor_style = "BlinkingBlock"
    config.cursor_blink_ease_in = "Linear"
    config.cursor_blink_ease_out = "Linear"
    config.cursor_blink_rate = 500

    -- Inactive dimming
    config.inactive_pane_hsb = {
        saturation = 0.8,
        brightness = 0.5,

    }

    -- Window
    config.window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0
    }

    config.colors = {
        -- Tab bar. See `./tab-bar.lua` for more config
        tab_bar = {
            background = stdcolors.background,
            new_tab = {
                bg_color = stdcolors.background,
                fg_color = stdcolors.accent1,
                intensity = "Bold",
            },
        },
    }
    return config
end
