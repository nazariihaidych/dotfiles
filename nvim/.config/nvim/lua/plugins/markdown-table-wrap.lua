return {
    "ice345/markdown-table-wrap.nvim",
    enabled = false,
    ft = "markdown",
    opts = {
        preview_mode = "inline",
        auto_preview = true,
    },
    keys = {
        { "<leader>tp", "<cmd>MarkdownTableTogglePreview<cr>", ft = "markdown", desc = "Toggle table preview" },
    },
}
