local function startDefault()
    vim.cmd("Startup display")
end

local function startTelescope(directory)
    vim.cmd("Telescope find_files cwd=" .. directory)
end

local args = vim.fn.argv()
local arg_type = nil

if #args == 0 then
    arg_type = "default"
elseif #args >= 1 then
    if vim.fn.isdirectory(args[1]) == 1 then
        arg_type = "directory"
    else
        arg_type = "file"
    end
end


if arg_type == "default" then
    vim.api.nvim_create_autocmd("User", {
        pattern = "LazyLoad",
        callback = function(event)
            local plugin_name = event.data
            if plugin_name == "startup.nvim" then
                startDefault()
            end
        end
    })
elseif arg_type == "directory" then
    vim.api.nvim_create_autocmd("User", {
        pattern = "LazyLoad",
        callback = function(event)
            local plugin_name = event.data
            if plugin_name == "telescope.nvim" then
                startTelescope(args[1])
            end
        end
    })
end
