return {
    {
        "tpope/vim-dadbod",
        lazy = false,
        config = function()
            vim.g.db_ui_save_location = "~/.local/share/db_ui"
            vim.g.db_ui_show_help = 0
            local env_dbs = vim.fn.getenv("DB_ENVS")
            if not env_dbs or env_dbs == "" then
                return
            end

            local dbs = {}
            for name, env_name in string.gmatch(env_dbs, "([^:]+):([^,]+),?") do
                local conn = vim.fn.getenv(env_name)
                if conn and conn ~= "" then
                    table.insert(dbs, {
                        name = name,
                        url = conn,
                    })
                end
            end
            vim.g.dbs = dbs
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_execute_on_save = 0
            vim.g.db_ui_winwidth = 50
        end
    },
    {
        "kristijanhusak/vim-dadbod-ui",
        lazy = false,
    },
    {
        "kristijanhusak/vim-dadbod-completion",
        lazy = false,
    },
}
