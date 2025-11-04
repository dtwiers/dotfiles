return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile", "SessionLoadPost" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
        -- cmp capabilities
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Global LSP client flags (work around incremental sync nil crash)
        local client_flags = {
            allow_incremental_sync = false, -- <- avoids sync.lua prev_line nil
            debounce_text_changes = 150,
        }

        -- Signs (gutter)
        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        -- helpers
        local function exepath(bin)
            local p = vim.fn.exepath(bin)
            return (p ~= "" and p) or nil
        end

        local function cmd_if(bin, args)
            local exe = exepath(bin)
            if not exe then
                -- vim.notify(("LSP skipped: %s not found in $PATH"):format(bin), vim.log.levels.WARN)
                return nil
            end
            local cmd = { exe }
            if args and #args > 0 then vim.list_extend(cmd, args) end
            return cmd
        end

        ---------------------------------------------------------------------------
        -- One place to set buffer-local keymaps & per-buffer toggles on attach
        ---------------------------------------------------------------------------
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
            callback = function(args)
                local bufnr = args.buf
                local opts = { noremap = true, silent = true, buffer = bufnr }

                -- Telescope-powered jumpers
                vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>",
                    vim.tbl_extend("force", opts, { desc = "LSP references" }))
                vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>",
                    vim.tbl_extend("force", opts, { desc = "LSP definitions" }))
                vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>",
                    vim.tbl_extend("force", opts, { desc = "LSP implementations" }))
                vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>",
                    vim.tbl_extend("force", opts, { desc = "LSP type definitions" }))

                -- Native LSP actions
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
                    vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
                vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
                    vim.tbl_extend("force", opts, { desc = "Code actions" }))
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,
                    vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
                vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover docs" }))

                -- Diagnostics
                vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>",
                    vim.tbl_extend("force", opts, { desc = "Buffer diagnostics" }))
                vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float,
                    vim.tbl_extend("force", opts, { desc = "Line diagnostics" }))
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev,
                    vim.tbl_extend("force", opts, { desc = "Prev diagnostic" }))
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next,
                    vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))

                -- LSP restart convenience
                vim.keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>",
                    vim.tbl_extend("force", opts, { desc = "Restart LSP" }))

                -- Inlay hints on by default (support 0.10/0.11 signatures)
                if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
                    local ok = pcall(vim.lsp.inlay_hint.enable, bufnr, true)           -- 0.10 style
                    if not ok then pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr }) end -- 0.11 style
                end
            end,
        })

        ---------------------------------------------------------------------------
        -- define/add helpers with new 0.11 API
        ---------------------------------------------------------------------------
        local function define(server, extra)
            local cfg = extra and vim.deepcopy(extra) or {}
            cfg.capabilities = vim.tbl_deep_extend("force", cfg.capabilities or {}, capabilities)
            cfg.flags = vim.tbl_deep_extend("force", client_flags, cfg.flags or {})
            vim.lsp.config(server, cfg)
            return server
        end

        local enable_list = {}
        local function add(name, extra) table.insert(enable_list, define(name, extra)) end

        ---------------------------------------------------------------------------
        -- Servers
        ---------------------------------------------------------------------------

        -- Web stack
        add("html")
        add("cssls")
        add("ts_ls") -- typescript-language-server
        add("tailwindcss", {
            init_options = {
                userLanguages = { elixir = "html-eex", eelixir = "html-eex", heex = "html-eex" },
            },
        })
        add("emmet_ls", {
            filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
        })
        add("graphql", {
            filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
        })
        -- svelte (with TS/JS change notify)
        do
            local cmd = cmd_if("svelteserver", { "--stdio" })
            if cmd then
                add("svelte", {
                    cmd = cmd,
                    on_attach = function(client, bufnr)
                        vim.api.nvim_create_autocmd("BufWritePost", {
                            buffer = bufnr,
                            pattern = { "*.js", "*.ts" },
                            callback = function(ctx)
                                if client.name == "svelte" then
                                    client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
                                end
                            end,
                        })
                    end,
                })
            end
        end

        -- Lua
        add("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    workspace = {
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                },
            },
            flags = {
                allow_incremental_sync = false, -- <- important
                debounce_text_changes = 150,
            },
        })

        -- Rust
        do
            local cmd = cmd_if("rust-analyzer")
            if cmd then add("rust_analyzer", { cmd = cmd }) end
        end

        -- Haskell
        do
            local cmd = cmd_if("haskell-language-server-wrapper", { "--lsp" })
            if cmd then add("hls", { cmd = cmd, filetypes = { "haskell", "lhaskell", "cabal" } }) end
        end

        -- Astro (guard on binary name; the lsp name is “astro”)
        do
            local cmd = cmd_if("astro-ls", { "--stdio" })
            if cmd then add("astro", { cmd = cmd }) end
        end

        -- Prisma
        add("prismals")

        -- Purescript
        add("purescriptls")

        -- Python
        add("pyright")

        -- (Optional) Elixir — uncomment when you want it:
        -- do
        --   local candidates = {
        --     "/Users/you/dev-tools/elixir-ls-release/language_server.sh",
        --     "/opt/homebrew/bin/elixir-ls",
        --   }
        --   for _, path in ipairs(candidates) do
        --     if vim.fn.filereadable(path) == 1 then
        --       add("elixirls", { cmd = { path } })
        --       break
        --     end
        --   end
        -- end

        ---------------------------------------------------------------------------
        -- Enable
        ---------------------------------------------------------------------------
        vim.lsp.enable(enable_list)
    end,
}
