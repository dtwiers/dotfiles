-- local _edenEast = {
-- 	"EdenEast/nightfox.nvim",
-- 	priority = 1000,
-- 	config = function()
-- 		require("nightfox").setup({
-- 			options = {
-- 				-- transparent = true,
-- 			},
-- 		})
-- 		vim.cmd([[colorscheme carbonfox]])
-- 	end,
-- }

-- local flexoki = {
--     "kepano/flexoki-neovim",
--     config = function()
--         require("flexoki").setup()
--         vim.cmd([[colorscheme flexoki-dark]])
--     end,
-- }

local onedark = {
    "navarasu/onedark.nvim",
    config = function()
        require("onedark").setup {
            style = "darker",

            colors = {
                bg0 = "#0e1013"
            },
        }
        vim.cmd([[colorscheme onedark]])
    end,
}
return onedark
