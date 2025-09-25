local wezterm = require 'wezterm'
local utils = require 'utils'
return function(config)
    -- background
    local background = {
        source = {
            Color = 'black',
        },
        height = "100%",
        width = "100%",
        hsb = { brightness = 0.18 },
        attachment = "Fixed",
        opacity = 0.95,
    }

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
                harfbuzz_features={ 'calt', 'liga', 'dlig', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08' },
            }
        )

        config.font_size = 19.5
    else
        config.font = wezterm.font('VictorMono Nerd Font', {
            weight = 'DemiBold',
            stretch = 'Normal',
            style = 'Normal',
        })
        config.font_size = 15
    end

    config.animation_fps = 60
    config.background = { background }

    config.color_scheme = 'Dissonance (Gogh)'

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
        -- Tab bar. See `./tab-bar.lua for more config`
        tab_bar = {
            background = "#0e1013",
            new_tab = {
                bg_color = "#0e1013",
                fg_color = "#039660",
                intensity = "Bold",
            },
        },
    }
    return config
end
