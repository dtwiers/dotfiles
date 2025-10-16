local keyset = vim.keymap.set

-- Env toggles
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

-- Optional Copilot Chat (no hard build step)
local copilot_chat = {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
        {"zbirenbaum/copilot.lua"},
        {"nvim-lua/plenary.nvim"}
    },
    -- build = "make tiktoken", -- optional; see docs for tiktoken_core install choices
    opts = {}
}

-- Codeium (vimscript plugin)
local codeium = {
    "Exafunction/codeium.vim",
    event = "BufEnter",
    config = function()
        -- Don’t let it bind default keys; we set our own
        vim.g.codeium_disable_bindings = 1

        local opts = {expr = true, silent = true}
        keyset(
            "i",
            "<S-Tab>",
            function()
                return vim.fn["codeium#Accept"]()
            end,
            opts
        )
        -- Be careful with Ctrl+Shift combos in terminals; they often don’t survive
        keyset(
            "i",
            "<C-;>",
            function()
                return vim.fn
            end,
            opts
        )
        keyset(
            "i",
            "<M-;>",
            function()
                return vim.fn["codeium#CycleCompletions"](-1)
            end,
            opts
        )
        keyset(
            "i",
            "<C-e>",
            function()
                return vim.fn["codeium#Clear"]()
            end,
            opts
        ) -- mirror Copilot dismiss
        keyset(
            "n",
            "<leader>ac",
            function()
                return vim.fn["codeium#Complete"]()
            end,
            {silent = true}
        )
    end
}

-- Parrot with built-in Ollama provider (correct endpoint; no custom glue needed)
local parrot = {
    "frankroeder/parrot.nvim",
    dependencies = {"ibhagwan/fzf-lua", "nvim-lua/plenary.nvim"},
    opts = {
        providers = {
            ollama = {
                name = "ollama",
                endpoint = "http://localhost:11434/api/chat", -- parrot’s expected Ollama endpoint
                api_key = "", -- not required
                params = {
                    chat = {max_tokens = 2048, top_p = 0.9, min_p = 0.05, num_ctx = 163840, temperature = 0.5},
                    command = {max_tokens = 1024, top_p = 0.8, min_p = 0.05, num_ctx = 163840, temperature = 0.35}
                },
                models = {"deepseek-coder-v2:16b"}
            }
        },
        default_provider = "ollama"
    }
}

-- Assemble plugin list
local plugins = {}

if use_copilot then
    table.insert(plugins, copilot)
-- table.insert(plugins, copilot_chat)
end

if not disable_codeium then
    table.insert(plugins, codeium)
end

if use_ollama then
    table.insert(plugins, parrot)
end

return plugins

