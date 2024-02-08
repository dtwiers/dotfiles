return {
    "mhartington/formatter.nvim",
    config = function()
        require("formatter").setup({
            logging = true,
            log_level = vim.log.levels.WARN,
            filetype = {
                javascript = {
                    require("formatter.filetypes.javascript")
                },
                javascriptreact = {
                    require("formatter.filetypes.javascriptreact")
                },
                typescript = {
                    require("formatter.filetypes.typescript")
                },
                typescriptreact = {
                    require("formatter.filetypes.typescriptreact")
                },
                lua = {
                    require("formatter.filetypes.lua")
                },
                json = {
                    require("formatter.filetypes.json")
                },
                haskell = {
                    require("formatter.filetypes.haskell")
                },
                html = {
                    require("formatter.filetypes.html")
                },
                css = {
                    require("formatter.filetypes.css")
                },
                sql = {
                    require("formatter.filetypes.sql")
                },
                markdown = {
                    require("formatter.filetypes.markdown")
                },
                yaml = {
                    require("formatter.filetypes.yaml")
                },
                python = {
                    require("formatter.filetypes.python")
                },
                go = {
                    require("formatter.filetypes.go")
                },
                rust = {
                    require("formatter.filetypes.rust")
                }
            },
        })

    end,
}
