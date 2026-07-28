-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

--my own finds
--
--update/write file (config) & source it
keymap.set("n", "<Leader>so", ":update<CR> :source<CR>")
-- write file
keymap.set("n", "<Leader>wr", ":write<CR>")

--Neorg
--
-- Defolt notes spase in Neorg
keymap.set("n", "<Leader>Nd", ":Neorg workspace notes<CR>")
-- check/uncheck/paused todo-item
keymap.set(
  "n",
  "<LocalLeader>;",
  "<Plug>(neorg.qol.todo-items.todo.task-cycle)",
  { desc = "check/uncheck/paused todo-item" }
)

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- New tab
keymap.set("n", "te", ":tabedit<CR>")
keymap.set("n", "<Tab>", ":tabnext<Return>", opts)
keymap.set("n", "<S-Tab>", ":tabprev<Return>", opts)

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

--toggle concealer (rendering of markup)
keymap.set("n", "<LocalLeader>C", "<cmd>Neorg toggle-concealer<CR>", { desc = "toggle-concealer" })

-- Diagnostics
keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)

--
-- return {
--   -- Глобальні мапінги (заміна або додавання)
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       -- Налаштування <leader> (якщо хочете змінити)
--       -- defaults = { leader = " " },
--     },
--     config = function()
--       vim.g.maplocalleader = ","
--
--       local keymap = vim.keymap
--       local opts = { noremap = true, silent = true }
--
--       -- Стандартні налаштування
--       keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
--       keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)
--
--       -- Робота з вкладками
--       keymap.set("n", "te", ":tabedit<CR>", opts)
--       keymap.set("n", "<Tab>", ":tabnext<CR>", opts)
--       keymap.set("n", "<S-Tab>", ":tabprev<CR>", opts)
--
--       -- Спліти
--       keymap.set("n", "ss", ":split<CR>", opts)
--       keymap.set("n", "sv", ":vsplit<CR>", opts)
--
--       --  Переміщення між вікнами
--       keymap.set("n", "sh", "<C-w>h", opts)
--       keymap.set("n", "sk", "<C-w>k", opts)
--       keymap.set("n", "sj", "<C-w>j", opts)
--       keymap.set("n", "sl", "<C-w>l", opts)
--
--       -- Простір для нотаток
--       keymap.set("n", "<Leader>Nd", ":Neorg workspace notes<CR>", opts)
--
--       --  Діагностика LSP
--       keymap.set("n", "<C-j>", function()
--         vim.diagnostic.goto_next()
--       end, opts)
--     end,
--   },
-- }
