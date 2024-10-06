return {
	"EdenEast/nightfox.nvim",
	priority = 1000,
	config = function()
        local palettes = {
            carbonfox = {
                bg0 = "#030303",
                bg1 = "#030303",
                bg2 = "#030303",
            }
        }
		require("nightfox").setup({
            palettes = palettes,
			options = {
				-- transparent = true,
			},
		})
		vim.cmd([[colorscheme carbonfox]])
	end,
}
