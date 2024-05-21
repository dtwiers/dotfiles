return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile", "SessionLoadPost" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
        -- import lspconfig plugin
        local lspconfig = require("lspconfig")

        -- local function attach_lsp_to_all_buffers()
        --     for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        --         if vim.api.nvim_buf_is_loaded(bufnr) then
        --             local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
        --             local lsp = lspconfig[ft]
        --             if lsp then
        --                 -- Attempt to attach the LSP server to the buffer
        --                 lsp.manager.try_add(bufnr)
        --             end
        --         end
        --     end
        -- end
        --
        -- -- Setup the auto-command to run the function after sessions are loaded
        -- -- Replace 'SessionLoadPost' with the actual event you're using to finish loading a session
        -- vim.api.nvim_create_autocmd('SessionLoadPost', {
        --     group = vim.api.nvim_create_augroup('LspAttachOnSessionLoad', { clear = true }),
        --     pattern = '*',
        --     callback = attach_lsp_to_all_buffers,
        -- })
        --
        -- import cmp-nvim-lsp plugin
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local keymap = vim.keymap -- for conciseness

        local opts = { noremap = true, silent = true }
        local on_attach = function(client, bufnr)
            opts.buffer = bufnr

            -- set keybinds
            opts.desc = "Show LSP references"
            keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

            opts.desc = "Go to declaration"
            keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

            opts.desc = "Show LSP definitions"
            keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

            opts.desc = "Show LSP implementations"
            keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

            opts.desc = "Show LSP type definitions"
            keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

            opts.desc = "See available code actions"
            keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

            opts.desc = "Smart rename"
            keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

            opts.desc = "Show buffer diagnostics"
            keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

            opts.desc = "Show line diagnostics"
            keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

            opts.desc = "Go to previous diagnostic"
            keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

            opts.desc = "Go to next diagnostic"
            keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

            opts.desc = "Show documentation for what is under cursor"
            keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

            opts.desc = "Restart LSP"
            keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
        end

        -- used to enable autocompletion (assign to every lsp server config)
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Change the Diagnostic symbols in the sign column (gutter)
        -- (not in youtube nvim video)
        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        local setup = function(name, extra_config, suppress_standard)
            local config = {}
            if not suppress_standard then
                config.on_attach = on_attach
                config.capabilities = capabilities
            end
            if extra_config then
                for k, v in pairs(extra_config) do
                    config[k] = v
                end
            end
            lspconfig[name].setup(config)
        end


        local servers = {
            "html",
            "tsserver",
            "cssls",
            "tailwindcss",
            "astro",
            "rust_analyzer",
            "prismals",
            -- "ocammllsp",
            { "hls",      { filetypes = { "haskell", "lhaskell", "cabal" } } },
            "purescriptls",
            { "graphql",  { filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" } } },
            { "emmet_ls", { filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" } } },
            "pyright",
            { "svelte", {
                on_attach = function(client, bufnr)
                    on_attach(client, bufnr)

                    vim.api.nvim_create_autocmd("BufWritePost", {
                        pattern = { "*.js", "*.ts" },
                        callback = function(ctx)
                            if client.name == "svelte" then
                                client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
                            end
                        end,
                    })
                end,
            } },
            { "lua_ls", {
                settings = { -- custom settings for lua
                    Lua = {
                        -- make the language server recognize "vim" global
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            -- make language server aware of runtime files
                            library = {
                                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                [vim.fn.stdpath("config") .. "/lua"] = true,
                            },
                        },
                    },
                },
            } },
        }

        local elixir_ls_path = nil
        local elixir_ls_paths = {
            "/Users/derekwiers/dev-tools/elixir-ls-release/language_server.sh",
            "/Users/derek/dev-tools/elixir-ls-release/language_server.sh",
            "/opt/homebrew/bin/elixir-ls",
        }
        for _, path in ipairs(elixir_ls_paths) do
            if vim.fn.filereadable(path) == 1 then
                elixir_ls_path = path
                break
            end
        end

        if elixir_ls_path ~= nil then
            table.insert(servers, { "elixirls", { cmd = { elixir_ls_path } } })
        end

        for _, server in ipairs(servers) do
            if type(server) == "string" then
                setup(server)
            else
                setup(server[1], server[2], server[3])
            end
        end

    end,
}
