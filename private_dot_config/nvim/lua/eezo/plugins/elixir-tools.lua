return {
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local elixir = require("elixir")
        local elixirls = require("elixir.elixirls")

        elixir.setup {
            nextls = { enable = false },
            elixirls = {
                enable = true,
                settings = elixirls.settings {
                    dialyzerEnabled = true,
                    enableTestLenses = true,
                },
                on_attach = function(client, bufnr)
                    vim.keymap.set("n", "<leader>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
                    vim.keymap.set("n", "<leader>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
                    vim.keymap.set("v", "<leader>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
                    vim.keymap.set("n", "<leader>Tr", ":lua vim.lsp.codelens.run()<cr>", { buffer = true, noremap = true })
                end,
            },
            projectionist = {
                enable = true
            }
        }
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
}
