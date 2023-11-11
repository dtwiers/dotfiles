return {
    'nvim-treesitter/nvim-treesitter',
    config = function()
        require('nvim-treesitter.configs').setup({
            ensure_installed = { "typescript", "javascript", "toml", "sql", "css", "scss", "rust", "vue", "lua", "prisma", "php", "astro",
                "dockerfile", "bash", "c", "json5", "yaml", "xml", },
            auto_install = true,

            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },

        })
    end
}