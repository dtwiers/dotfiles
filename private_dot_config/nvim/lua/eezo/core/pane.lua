local map = vim.keymap.set
local normal_map = function(keymap, command)
    map('n', keymap, command, { noremap = true, silent = true })
end

local leadermap = function(keymap, command)
    normal_map('<leader>' .. keymap, command)
end


normal_map('H', '<C-w>h')
normal_map('J', '<C-w>j')
normal_map('K', '<C-w>k')
normal_map('L', '<C-w>l')


local resize_split = function(direction)
    local resize_coefficient = 0.10
    local max_resize = 16
    local min_resize = 1

    local resize_amount = math.min(max_resize,
        math.max(min_resize, math.floor(vim.api.nvim_win_get_width(0) * resize_coefficient)))

    if direction == "grow" then
        vim.cmd("vertical resize +" .. resize_amount)
    elseif direction == "shrink" then
        vim.cmd("vertical resize -" .. resize_amount)
    end
end

leadermap('p>', function()
    resize_split("grow")
end)
leadermap('p<', function()
    resize_split("shrink")
end)
