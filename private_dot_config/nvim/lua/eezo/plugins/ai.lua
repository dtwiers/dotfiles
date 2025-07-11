local keyset = vim.keymap.set

local use_copilot = vim.env.USE_COPILOT ~= nil
local use_ollama = vim.env.USE_OLLAMA ~= nil

local copilot = {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
        require("copilot").setup({
            suggestion = {
                enabled = true,
                auto_trigger = true,
                debounce = 75,
                keymap = {
                    accept = "<S-Tab>",
                    accept_word = false,
                    accept_line = false,
                    next = "<C-]>",
                    prev = "<C-[>",
                    dismiss = "<C-e>",
                },
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
                ["*"] = false, -- turns it off for everything else
            },
        })
    end
}

local copilot_chat =
{
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
        { "zbirenbaum/copilot.lua" },                   -- or zbirenbaum/copilot.lua
        { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken",                            -- Only on MacOS or Linux
    opts = {
        -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
}

local codeium = {
    'Exafunction/codeium.vim',
    event = 'BufEnter',
    config = function()
        vim.g.codeium_disable_bindings = 1
        local opts = { expr = true, silent = true }
        keyset('i', '<S-Tab>', function() return vim.fn['codeium#Accept']() end, opts)
        keyset('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, opts)
        keyset('i', '<c-s-;>', function() return vim.fn['codeium#CycleCompletions'](-1) end, opts)
        keyset('i', '<c-c>', function() return vim.fn['codeium#Clear']() end, opts)
        keyset('n', '<c-s-c>', function() return vim.fn['codeium#Complete']() end, opts)
    end,
}

-- warning: this config doesn't work yet for some reason
local parrot = {
    "frankroeder/parrot.nvim",
    dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim" },
    opts = {},
    config = function()
        require("parrot").setup {
            providers = {
                ollama = {
                    name = "ollama",
                    endpoint = "http://localhost:11434/v1/chat/completions",
                    api_key = "",
                    models = { "deepseek-coder-v2:16b" },
                    params = {
                        chat = {
                            max_tokens = 2048,
                            top_p = 0.9,
                            min_p = 0.05,
                            num_ctx = 163840,
                            temperature = 0.5,
                        },
                        command = {
                            max_tokens = 1024,
                            top_p = 0.8,
                            min_p = 0.05,
                            num_ctx = 163840,
                            temperature = 0.35,
                        },
                    },
                    resolve_api_key = function()
                        return ""
                    end,
                    process_stdout = function(response)
                        if response:match "message" and response:match "content" then
                            local ok, data = pcall(vim.json.decode, response)
                            if ok and data.message and data.message.content then
                                return data.message.content
                            end
                        end
                    end,
                    get_available_models = function(self)
                        local url = self.endpoint:gsub("chat", "")
                        local logger = require "parrot.logger"
                        local job = Job:new({
                            command = "curl",
                            args = { "-H", "Content-Type: application/json", url .. "tags" },
                        }):sync()
                        local parsed_response = require("parrot.utils").parse_raw_response(job)
                        self:process_onexit(parsed_response)
                        if parsed_response == "" then
                            logger.debug("Ollama server not running on " .. endpoint_api)
                            return {}
                        end

                        local success, parsed_data = pcall(vim.json.decode, parsed_response)
                        if not success then
                            logger.error("Ollama - Error parsing JSON: " .. vim.inspect(parsed_data))
                            return {}
                        end

                        if not parsed_data.models then
                            logger.error "Ollama - No models found. Please use 'ollama pull' to download one."
                            return {}
                        end

                        local names = {}
                        for _, model in ipairs(parsed_data.models) do
                            table.insert(names, model.name)
                        end

                        return names
                    end
                },
            },
            default_provider = "ollama",
        }
    end
}

local plugins = {}

if use_copilot then
    table.insert(plugins, copilot)
    -- table.insert(plugins, copilot_chat)
else
    table.insert(plugins, codeium)
end

if use_ollama then
    table.insert(plugins, parrot)
end

return plugins
