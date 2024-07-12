vim.o.termguicolors = true
vim.filetype.add({ extension = { purs = 'purescript' }})
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
normal_map('<leader>u', ":set @a = substitute(system(\"uuidgen | awk '{print tolower($0)}'\"), '\n', '', 'g')<CR>")
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

normal_map('<leader>tn', ':tabnew<CR>')
normal_map('<leader>tc', ':tabclose<CR>')
normal_map('<leader>th', ':tabnext<CR>')
normal_map('<leader>tl', ':tabprevious<CR>')
normal_map('<leader>to', ':tabonly<CR>')

normal_map('<leader>/', ':noh<CR>')

local listcharsOptions = {
    tab = '▷ ',
    trail = '~',
    extends = '❯',
    precedes = '❮',
    lead = '·',
    nbsp = '␣',
}
local listcharsArray = {}
for key, value in pairs(listcharsOptions) do
    table.insert(listcharsArray, key .. ':' .. value)
end
vim.o.listchars = table.concat(listcharsArray, ',')
vim.o.list = true
