return {
    "TaDaa/vimade",
    config = function()
        require("vimade").setup()
        vim.g.vimade = {
            fadelevel = 0.9,
            basebg = "#5542ff",
        }
    end,
}
