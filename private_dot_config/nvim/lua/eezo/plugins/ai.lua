local keyset = vim.keymap.set

-- Env toggles
local usage = vim.env.USAGE
local use_copilot = vim.env.USE_COPILOT ~= nil
local use_ollama = vim.env.USE_OLLAMA ~= nil
local disable_codeium = vim.env.DISABLE_CODEIUM ~= nil

-- Enforce mutual exclusivity between Copilot and Codeium
-- Default: prefer Codeium unless USE_COPILOT is set
if use_copilot then
    disable_codeium = true
end

-- Copilot (suggestion-only)
local copilot = {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
        require("copilot").setup(
            {
                -- If your corporate image has older Node, set copilot_node_command explicitly
                -- copilot_node_command = "/usr/bin/node",
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 75,
                    -- Avoid <C-[> (Esc); use Alt like the defaults
                    keymap = {
                        accept = "<S-Tab>",
                        accept_word = false,
                        accept_line = false,
                        next = "<C-]>", -- keep if you like; default is <M-]>
                        prev = "<M-[>", -- ESC-safe; default is <M-[>
                        dismiss = "<C-e>"
                    }
                },
                filetypes = {
                    elixir = true,
                    erlang = true,
                    sql = true,
                    javascript = true,
                    typescript = true,
                    python = true,
                    ocaml = true,
                    rust = true,
                    php = true,
                    lua = true,
                    go = true,
                    ["*"] = false
                }
            }
        )
    end
}

local codecompanion = {
    "olimorris/codecompanion.nvim",
    opts = {},
    dependencies = {
        "nvim-lua/plenary.nvim",
        "ravitemer/mcphub.nvim",
    },
    config = function()
        require("codecompanion").setup({
            extensions = {
                mcphub = {

                    callback = "mcphub.extensions.codecompanion",
                    opts = {
                        make_vars = true,
                        make_slash_commands = true,
                        show_result_in_chat = true
                    }
                }
            }
        })
    end,
}

-- Assemble plugin list
local plugins = {}

if use_copilot then
    table.insert(plugins, copilot)
    -- table.insert(plugins, copilot_chat)
end

if not disable_codeium then
    table.insert(plugins, codecompanion)
    return {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            -- NOTE: The log_level is in `opts.opts`
            opts = {
                log_level = "DEBUG", -- or "TRACE"
            },
        },
    }
end

if use_ollama then
    table.insert(plugins, parrot)
end

return plugins

