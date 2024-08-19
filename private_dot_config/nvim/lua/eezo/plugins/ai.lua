-- return {
--     "github/copilot.vim",
-- }

-- return {
--     'codota/tabnine-nvim',
--     event = "InsertEnter",
--     build = './dl_binaries.sh',
--     config = function()
--         require('tabnine').setup({
--             disable_auto_comment=true,
--             accept_keymap="<S-Tab>",
--             dismiss_keymap = "<C-]>",
--             debounce_ms = 800,
--             suggestion_color = {gui = "#808080", cterm = 244},
--             exclude_filetypes = {"TelescopePrompt", "NvimTree"},
--             log_file_path = nil, -- absolute path to Tabnine log file
--         })
--     end,
-- }

return {
    'Exafunction/codeium.vim',
    event = 'BufEnter',
    config = function()
        vim.g.codeium_disable_bindings = 1
        local opts = {expr = true, silent = true}
        vim.keymap.set('i', '<S-Tab>', function() return vim.fn['codeium#Accept']() end, opts)
        vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, opts)
        vim.keymap.set('i', '<c-s-;>', function() return vim.fn['codeium#CycleCompletions'](-1) end, opts)
        vim.keymap.set('i', '<c-c>', function() return vim.fn['codeium#Clear']() end, opts)
        vim.keymap.set('n', '<c-s-c>', function() return vim.fn['codeium#Complete']() end, opts)
    end,
}
