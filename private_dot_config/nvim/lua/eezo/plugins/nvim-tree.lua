return {}
-- return {
--     "nvim-tree/nvim-tree.lua",
--     dependencies = {
--         "nvim-tree/nvim-web-devicons",
--     },
--     config = function()
--         local nvt = require("nvim-tree")
--
--         -- recommended settings
--         -- vim.g.loaded_netrw = 1
--         -- vim.g.loaded_netrwPlugin = 1
--
--         nvt.setup({
--             view = {
--                 width = 40,
--             },
--         })
--
--         local map = vim.keymap.set
--
--         map('n', '<leader>ee', "<cmd>NvimTreeToggle<CR>")
--         map('n', '<leader>ef', '<cmd>NvimTreeFindFileToggle<CR>')
--         map('n', '<leader>ec', '<cmd>NvimTreeCollapse<CR>')
--         map('n', '<leader>er', '<cmd>NvimTreeRefresh<CR>')
--     end
-- }
