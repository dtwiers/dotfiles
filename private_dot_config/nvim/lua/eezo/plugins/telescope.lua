return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    config = function()
        local builtin = require('telescope.builtin')
        local actions = require('telescope.actions')
        local map = vim.keymap.set

        map('n', '<leader>ff', builtin.find_files, {})
        map('n', '<leader>fg', builtin.live_grep, {})
        map('n', '<leader>fb', builtin.buffers, {})
        map('n', '<leader>fh', builtin.help_tags, {})

        -- Main telescope config
        require('telescope').setup({
            defaults = {
                mappings = {
                    n = {
                        ["<leader>pl"] = actions.select_vertical,
                        ["<leader>pj"] = actions.select_horizontal,
                        ["<leader>tn"] = actions.select_tab,
                    },
                },
            },
        })

        -- Disable NetRW
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- Check if Neovim is opened with a directory
    --     vim.api.nvim_create_autocmd("VimEnter", {
    --         pattern = "*",
    --         callback = function()
    --             if vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
    --                 vim.cmd('bd1')
    --                 vim.cmd('Telescope find_files')
    --             end
    --         end,
    --     })
    end,
}
