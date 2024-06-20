return {
    "elihunter173/dirbuf.nvim",
    config = function()
        require("dirbuf").setup {
            hash_padding = 2,
            show_hidden = true,
            sort_order = "default",
            write_cmd = "DirbufSync",
        }
        _G.open_dirbuf = function()
            local current_buffer = vim.api.nvim_get_current_buf()
            local current_file = vim.api.nvim_buf_get_name(current_buffer)
            local current_dir = vim.fn.fnamemodify(current_file, ":p:h")
            vim.cmd('tabnew ' .. current_dir)
            vim.cmd('Dirbuf')
        end

        vim.api.nvim_set_keymap('n', '<leader>b', ':lua open_dirbuf()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>fe', ':Dirbuf<CR>', { noremap = true, silent = true })
    end
}
