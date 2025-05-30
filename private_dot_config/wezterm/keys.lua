local wezterm = require("wezterm")
return function(config)
    config.leader = { key = "Enter", mods = "CTRL|SHIFT", timeout_milliseconds = 1000 }
    config.keys = {
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
    return config
end
