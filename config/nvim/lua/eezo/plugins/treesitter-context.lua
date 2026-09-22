return {
    "nvim-treesitter/nvim-treesitter-context",
    branch = "master",
    config = function()
        require("treesitter-context").setup {
            enable = true,
        }
    end,
}
