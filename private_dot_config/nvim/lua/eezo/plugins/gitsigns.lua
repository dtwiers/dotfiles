return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup({
            current_line_blame = true,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol",
                delay = 30,
            },
            current_line_blame_formatter = "<author>, <abbrev_sha> :: <author_time:%Y-%m-%d> - <summary>",
        })
        local function blame_line()
            require("gitsigns").blame_line({full = true})
        end

        vim.keymap.set("n", "<leader>cs", blame_line, { desc = "Show blame line" })

    end,
}

