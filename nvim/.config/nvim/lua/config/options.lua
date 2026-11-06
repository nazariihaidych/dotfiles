
--vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.shiftwidth = 4 -- Amount to indent with << and >>
vim.opt.tabstop = 4 -- How many spaces are shown per Tab
vim.opt.softtabstop = 4 -- How many spaces are applied when pressing Tab

vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true -- Keep identation from previous line

-- Enable break indent
vim.opt.breakindent = true

-- Soft-wrap long lines at word boundaries instead of mid-word
vim.opt.linebreak = true

-- Always show relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Show line under cursor
vim.opt.cursorline = true

-- Store undos between sessions
vim.opt.undofile = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", extends = "→", precedes = "←" }

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Default border for all floating windows (LSP hover, signature help,
-- diagnostics, help popups, Lazy/Mason UIs, etc.). Neovim 0.11+ global option.
-- "none" | "single" | "double" | "rounded" | "solid" | "shadow"
vim.opt.winborder = "rounded"

-- Make floating windows & the completion popup a bit transparent.
-- (The editor splits are already transparent via the theme's `transparent = true`
--  plus the terminal's background opacity; winblend/pumblend only affect floats.)
-- Range 0 (opaque) .. 100 (fully transparent); ~10-15 = "a bit".
-- vim.opt.winblend = 12 -- floating windows (hover, LSP, which-key, etc.)
-- vim.opt.pumblend = 12 -- popup menu (completion)

-- Highlight text for some time after yanking
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = "Highlight yank",
})

-- `:help` opens as a split, which can't have a border. Convert the help window
-- into a centered floating window so it picks up a border (like other floats).
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("HelpFloat", { clear = true }),
  pattern = { "help", "man" },
  callback = function(args)
    if not vim.bo[args.buf].buflisted then
      local win = vim.api.nvim_get_current_win()
      local width = math.min(120, math.floor(vim.o.columns * 0.85))
      local height = math.floor(vim.o.lines * 0.85)
      pcall(vim.api.nvim_win_set_config, win, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        border = "rounded",
      })
    end
  end,
  desc = "Open help/man in a bordered floating window",
})

