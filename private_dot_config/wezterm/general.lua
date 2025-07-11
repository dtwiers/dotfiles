local wezterm = require("wezterm")
return function(config)
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

    config.scrollback_lines = 80000
    config.native_macos_fullscreen_mode = true

    config.initial_rows = 48
    config.initial_cols = 160

    return config
end
