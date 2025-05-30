local wezterm = require("wezterm")
return function(config)
    config.tab_bar_at_bottom = true
    config.use_fancy_tab_bar = false
    config.tab_max_width = 64

    wezterm.on(
        'format-tab-title',
        function(tab, tabs, panes, config, hover, max_width)
            return require("tabs").format_tab(tab, tabs, panes, config, hover, max_width)
        end
    )

    return config
end
