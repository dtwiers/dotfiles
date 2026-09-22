return {
    "norcalli/nvim-colorizer.lua",
    config = function()
        require("colorizer").setup(nil, {
            rgb_fn = true,
            hsl_fn = true,
            css = true,
            css_fn = true,
        })
    end
}

