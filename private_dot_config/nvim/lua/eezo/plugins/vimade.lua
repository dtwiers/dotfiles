return {
    "TaDaa/vimade",
    opts = {
        recipe = {'default', {animate = true}},
        ncmode = 'windows',
        fadelevel = 0.85,
        tint = {
            -- fg = {rgb = {85, 66, 255}, intensity = 0.3},
            -- fg = {rgb = {191, 191, 191}, intensity = 0.7},

            -- moonfly color 7
            fg = {rgb = {121, 218, 200}, intensity = 0.55},

            bg = {rgb = {0, 0, 0}, intensity = 0.9},
            -- I don't know what this does, so I am figuring out what turns red
            sp = {rgb = {255, 0, 0}, intensity = 0.7},
        },
    }
}
