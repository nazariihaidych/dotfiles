# Window (Pane) Navigation

Neovim splits are called "windows". This config currently has no custom
window-navigation plugin or keymaps, so navigation relies on the built-in
`<C-w>` prefix.

## Built-in keybindings

| Keys              | Action                                  |
|-------------------|------------------------------------------|
| `<C-w>h`          | Move to the window left                  |
| `<C-w>j`          | Move to the window below                 |
| `<C-w>k`          | Move to the window above                 |
| `<C-w>l`          | Move to the window right                 |
| `<C-w>w`          | Cycle to the next window                 |
| `<C-w>p`          | Jump back to the previous window         |
| `<C-w>=`          | Equalize window sizes                    |
| `{N}<C-w>w`       | Jump to window number `N`                |

## Possible improvement

Add direct `<C-h/j/k/l>` mappings to skip the `<C-w>` prefix:

```lua
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
```

If tmux is used alongside Neovim, a tmux-navigator style plugin lets the
same `<C-h/j/k/l>` keys cross between tmux panes and Neovim splits
seamlessly.

## Resizing windows

No custom resize keymaps exist in this config either, so resizing relies
on the built-in `<C-w>` prefix.

| Keys              | Action                                  |
|-------------------|------------------------------------------|
| `<C-w>+`          | Increase height                          |
| `<C-w>-`          | Decrease height                          |
| `<C-w>>`          | Increase width                           |
| `<C-w><`          | Decrease width                           |
| `<C-w>=`          | Equalize all window sizes                |
| `<C-w>_`          | Maximize height of current window        |
| `<C-w>\|`         | Maximize width of current window         |
| `{N}<C-w>+`       | Resize height by `N` (e.g. `5<C-w>+`)    |
| `{N}<C-w><`       | Resize width by `N` (e.g. `10<C-w><`)    |

### Possible improvement

Add repeatable arrow-key resize mappings:

```lua
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })
```
