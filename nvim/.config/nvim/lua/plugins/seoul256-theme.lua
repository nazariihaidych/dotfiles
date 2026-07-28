return {
    "junegunn/seoul256.vim",
    enabled = false,
    name = "seoul256",
    lazy = false,
    priority = 1000,
    config = function()
        -- seoul256 is a classic vim colorscheme, no setup() function needed
        -- You can set seoul256 options via vim variables if needed
        -- vim.g.seoul256_background = 233  -- example: set background darkness (233-239)

        -- Set the colorscheme
        vim.cmd("colorscheme seoul256")

        -- Apply custom overrides after loading the colorscheme
        vim.api.nvim_set_hl(0, "@markup.link.url.markdown_inline", { link = "Special" })
        vim.api.nvim_set_hl(0, "@markup.link.label.markdown_inline", { link = "WarningMsg" })
        vim.api.nvim_set_hl(0, "@markup.italic.markdown_inline", { link = "Exception" })
        vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline", { link = "String" })
        vim.api.nvim_set_hl(0, "@markup.list.markdown", { link = "Function" })
        vim.api.nvim_set_hl(0, "@markup.quote.markdown", { link = "Error" })
        vim.api.nvim_set_hl(0, "@markup.list.checked.markdown", { link = "WarningMsg" })
    end,
}
