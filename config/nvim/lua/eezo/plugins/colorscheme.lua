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
-- return {
--     "bluz71/vim-moonfly-colors",
--     name = "moonfly",
--     lazy = false,
--     priority = 1000,
--     config = function()
--         vim.g.moonflyCursorColor = true
--         vim.g.moonflyWinSeparator = 2
--         vim.cmd([[colorscheme moonfly]])
--     end,
-- }

-- return {
--     "miikanissi/modus-themes.nvim",
--     priority = 1000,
--     config = function()
--         vim.cmd([[colorscheme modus]])
--     end,
-- }

-- return {
--   "fuzztobread/notch2k.nvim",
--   priority = 1000, -- Load before other plugins
--   lazy = false,    -- Load during startup
--   config = function()
--     vim.cmd.colorscheme("notch2k")
--   end,
-- }

-- return {
--     "folke/tokyonight.nvim",
--     lazy = false,
--     priority = 1000,
--     opts = {},
-- }

-- return { "ellisonleao/gruvbox.nvim", priority = 1000 , config = function()
--         require("gruvbox").setup({
--             contrast = "soft",
--             -- palette_overrides = {
--             --     dark0_hard = "#1d2021",
--             --     dark0 = "#282828",
--             --     dark0_soft = "#32302f",
--             -- },
--         })
--         vim.cmd([[colorscheme gruvbox]])
--     end, opts = {}}
--

-- return {
--     "catppuccin/nvim",
--     name = "catppuccin",
--     lazy = false,
--     priority = 1000,
--     config = function()
--         require("catppuccin").setup({
--             flavour = "mocha", -- latte, frappe, macchiato, mocha
--             transparent_background = false,
--             integrations = {
--                 cmp = true,
--                 gitsigns = true,
--                 nvimtree = true,
--                 telescope = true,
--                 notify = true,
--                 treesitter = true,
--                 which_key = true,
--             },
--         })
--         vim.cmd([[colorscheme catppuccin]])
--     end,
-- }
-- return {
--     "rose-pine/neovim",
--     name = "rose-pine",
--     lazy = false,
--     priority = 1000,
--     config = function()
--         require("rose-pine").setup({
--             dark_variant = "moon",
--             disable_background = false,
--         })
--         vim.cmd([[colorscheme rose-pine]])
--     end,
-- }

return {
	"Shatur/neovim-ayu",
	name = "ayu",
	lazy = false,
	priority = 1000,
	config = function()
		require("ayu").setup({
			mirage = false,
			overrides = {
				Normal = { bg = "None" },
				NormalFloat = { bg = "#131721" },
				ColorColumn = { bg = "None" },
				SignColumn = { bg = "None" },
				Folded = { bg = "None" },
				FoldColumn = { bg = "None" },
				CursorLine = { bg = "None" },
				CursorColumn = { bg = "None" },
				VertSplit = { bg = "None" },
                LineNr = { fg = "#5C6370" },
			},
		})

		vim.cmd([[colorscheme ayu]])
	end,
}
