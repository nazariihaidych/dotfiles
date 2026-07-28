vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", {desc = "Open Parent Directory in Oil"})
vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end,
    {desc="Open Diagnostics in Float"}
)
vim.keymap.set("n", "<leader>L", "<cmd>:Lazy<CR>", {desc = "Lazy"})
vim.keymap.set("n", "<leader>M", "<cmd>:Mason<CR>", {desc = "Mason"})
vim.keymap.set("n", "<leader>m", "<cmd>:messages<CR>", {desc = "messages"})
vim.keymap.set("n", "<leader>cf", function()
    require("conform").format({
        lsp_format = "fallback",
    })
end, { desc = "Format current file" })

-- quite buffer
vim.keymap.set("n", "<leader>bd", ":bp<bar>bd #<CR>", { silent = true })
-- Copy to system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", '"+y', { desc = "Copy to system clipboard" })

-- Toggle line wrap (handy for markdown tables that misalign when a long cell soft-wraps)
vim.keymap.set("n", "<leader>tw", function()
    vim.opt_local.wrap = not vim.opt_local.wrap:get()
    vim.opt_local.sidescrolloff = 8
    vim.notify("wrap: " .. tostring(vim.opt_local.wrap:get()))
end, { desc = "Toggle wrap" })
