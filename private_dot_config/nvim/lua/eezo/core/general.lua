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
normal_map('<leader>tl', ':tabnext<CR>')
normal_map('<leader>th', ':tabprevious<CR>')
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
vim.o.scrolloff = 20

local warning_msg_hl = vim.api.nvim_get_hl(0, { name = 'MoonflyYellowMode' })

-- Define a custom highlight group based on 'WarningMsg'
vim.api.nvim_set_hl(0, 'TrailingSpaces', {
    fg = warning_msg_hl.fg or nil,
    bg = warning_msg_hl.bg or nil,
    underline = true, -- Optional: Add underline or other styling
})

-- Use the custom highlight group for trailing spaces
vim.api.nvim_create_autocmd('BufWinEnter', {
    pattern = '*',
    callback = function()
        vim.fn.matchadd('TrailingSpaces', '\\s\\+$') -- Highlight trailing spaces
    end,
})

-- Highlight lines with only spaces using the custom group
vim.api.nvim_create_autocmd('BufWinEnter', {
    pattern = '*',
    callback = function()
        vim.fn.matchadd('TrailingSpaces', '^\\s\\+$') -- Highlight lines with only spaces
    end,
})

-- Function to create a visual representation of highlight groups
_G.visualize_highlight_groups = function()
    local buf = vim.api.nvim_create_buf(false, true) -- Create a new scratch buffer
    local hl_groups = vim.fn.getcompletion('', 'highlight') -- Get all highlight group names
    for i, group in ipairs(hl_groups) do
        local hl = vim.api.nvim_get_hl(0, { name = group })
        vim.api.nvim_buf_set_lines(buf, i - 1, i, false, { group })
        if hl.fg or hl.bg then
            vim.api.nvim_buf_add_highlight(buf, -1, group, i - 1, 0, -1)
        end
    end
    vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = 50,
        height = #hl_groups,
        row = 5,
        col = 10,
        border = 'rounded', -- Optional: Add a rounded border to the floating window
    })
end

normal_map('<leader>hl', ':lua visualize_highlight_groups()<CR>')
