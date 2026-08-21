# Commit Message: Red Text After N Characters

When writing a commit message, the text turns **red** past a certain point.
This is not an error — it is Neovim's built-in `gitcommit` syntax
highlighting nudging you toward the standard commit-message convention.

## Why it happens

Neovim opens as `$GIT_EDITOR` and detects the `gitcommit` filetype. Its
built-in syntax rules flag lines that exceed the recommended limits:

- **Subject line (line 1): 50 characters.** Text past column 50 gets the
  `gitcommitOverflow` highlight (red).
- **Body lines: 72 characters.** Wrapped body text past column 72 can also
  be flagged.

This follows the widely-used git commit convention:

```
Short summary, 50 chars or less
<blank line>
Body wrapped at ~72 chars, explaining what and why
rather than how.
```

Git itself accepts messages of any length — the red is purely a visual
hint, not a hard limit.

## Options if you want to change it

### Show a guide column instead of coloring text

Add a `colorcolumn` for the `gitcommit` filetype so you get a vertical
marker at 50/72 instead of red text:

```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.colorcolumn = "50,72"
  end,
})
```

### Turn the overflow highlight off

```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.cmd("highlight! link gitcommitOverflow NONE")
    vim.cmd("highlight! link gitcommitSummary NONE")
  end,
})
```

### Leave it

Short subject lines keep `git log --oneline`, GitHub, and blame views
readable — the default is a good habit to keep.
