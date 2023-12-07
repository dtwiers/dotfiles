local map = vim.keymap.set
local normal_map = function(keymap, command)
    map('n', keymap, command, { noremap = true, silent = true })
end
vim.g.mapleader = " "
map('', '<Space>', '<Nop>', { noremap = true, silent = true })
normal_map('<leader>cf', '<cmd>lua vim.lsp.buf.format()<cr>')


vim.o.number = true
vim.o.expandtab = true
vim.o.smarttab = true

vim.o.shiftwidth = 4
vim.o.tabstop = 4

normal_map('<leader>pl', ':vsplit<CR>')
normal_map('<leader>pj', ':split<CR>')
vim.o.splitbelow = true
vim.o.splitright = true

map('n', '<leader>fn', ':e ' .. vim.fn.fnameescape(vim.fn.expand('%:p:h')) .. '/', { noremap = true, silent = false })

-- Astro
vim.filetype.add({
    extension = {
        astro = "astro"
    }
})

vim.filetype.add({
    extension = {
        mdx = "markdown.mdx",
    },
    filename = {},
    pattern = {},
})

-- set startup directory
local args = vim.fn.argv()
if #args > 0 and vim.fn.isdirectory(args[1]) >= 1 then
    vim.cmd('cd ' .. vim.fn.fnameescape(args[1]))
end


-- Auto-save session when leaving Neovim
-- vim.api.nvim_create_autocmd("VimLeave", {
--     pattern = "*",
--     callback = function()
--         local session_file = vim.fn.getcwd() .. '/Session.vim'
--         vim.cmd('mksession! ' .. vim.fn.fnameescape(session_file))
--     end
-- })
--
-- -- Function to load the session
-- local function load_session()
--     local session_file = vim.fn.getcwd() .. '/Session.vim'
--     if vim.fn.filereadable(session_file) == 1 then
--         vim.cmd('source ' .. vim.fn.fnameescape(session_file))
--     end
-- end
--
-- -- Auto-load session when entering Neovim
-- vim.api.nvim_create_autocmd("VimEnter", {
--     pattern = "*",
--     callback = function()
--         load_session()
--     end
-- })
