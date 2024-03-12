local edenEast = {
	"EdenEast/nightfox.nvim",
	priority = 1000,
	config = function()
		require("nightfox").setup({
			options = {
				-- transparent = true,
			},
		})
		vim.cmd([[colorscheme carbonfox]])
	end,
}

local flexoki = {
    "kepano/flexoki-neovim",
    config = function()
        require("flexoki").setup()
        vim.cmd([[colorscheme flexoki-dark]])
    end,
}

return flexoki
