return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    main = "nvim-treesitter",
    config = function()
        require("nvim-treesitter").setup({
            auto_install = true,
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<Enter>",
                    node_incremental = "<Enter>",
                    scope_incremental = false,
                    node_decremental = "<Backspace>",
                },
            },
        })

        require("nvim-treesitter").install({
            "c", "lua", "vim", "vimdoc", "query",
            "elixir", "heex", "javascript", "html", "csv",
        })
    end,
}
