return {
    "nvim-treesitter/nvim-treesitter-context",
    branch = "master",
    config = function()
        require("nvim-treesitter.configs").setup {
            enable = true,
        }
    end,
}
