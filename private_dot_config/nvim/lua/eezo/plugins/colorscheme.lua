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

-- local onedark = {
--     "navarasu/onedark.nvim",
--     config = function()
--         require("onedark").setup {
--             style = "darker",
--
--             colors = {
--                 -- bg0 = "#0e1013"
--                 bg0 = "#000000"
--             },
--         }
--         vim.cmd([[colorscheme onedark]])
--     end,
-- }
-- return onedark
-- return {
--   "craftzdog/solarized-osaka.nvim",
--   lazy = false,
--   priority = 1000,
--   opts = {},
--   config = function()
--     local hsl = require("solarized-osaka.hsl").hslToHex
--     require("solarized-osaka").setup({
--         transparent = false,
--         on_colors = function(colors)
--             colors.green = hsl(120, 100, 30)
--             colors.green500 = hsl(110, 100, 30)
--             colors.green700 = hsl(105, 100, 20)
--             colors.green900 = hsl(100, 100, 10)
--             colors.orange = hsl(24, 80, 44)
--             colors.orange100 = hsl(24, 100, 70)
--             colors.orange300 = hsl(24, 94, 51)
--             colors.orange500 = hsl(24, 80, 44)
--             colors.orange700 = hsl(24, 81, 35)
--             colors.orange900 = hsl(24, 80, 20)
--         end
--     })
--     vim.cmd([[colorscheme solarized-osaka]])
--   end,
-- }
return {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd([[colorscheme moonfly]])
    end,
}
