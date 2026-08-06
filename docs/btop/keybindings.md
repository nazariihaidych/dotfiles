# btop

Resource monitor (CPU, memory, disks, network, processes) — a drop-in
replacement for `top`/`htop` with a mouse-aware TUI, per-core graphs, disk
I/O, and a process tree view. Config: [`btop/.config/btop/btop.conf`](../../btop/.config/btop/btop.conf),
theme: [`btop/.config/btop/themes/btop-theme.theme`](../../btop/.config/btop/themes/btop-theme.theme).

Keybindings below are pulled from btop's own in-app help (`H`) on v1.4.7 —
not guessed from the changelog, so they match what's actually installed.

## Our config, at a glance

- `vim_keys = true` — `h j k l g G` work as directional keys in lists (see
  [Vim keys](#vim-keys-caveat) below for the `h`/`k` conflict).
- `color_theme = "btop-theme.theme"` — custom green/amber theme, see the
  `.theme` file for the palette.
- `proc_sorting = "memory"` — process list sorts by memory by default.
- `clock_format = "/user"` — clock in the CPU box shows your username
  instead of a time.
- Three custom layout presets are defined (see [Presets](#presets)).
- `rounded_corners = true`, `terminal_sync = true` — cosmetic/rendering,
  no functional effect on keys below.

## The four boxes

btop's screen is split into boxes, toggled individually:

| Key | Box |
|---|---|
| `1` | CPU |
| `2` | MEM (memory + disks) |
| `3` | NET |
| `4` | PROC (process list) |
| `5` | GPU (if present) |

## Global

| Key | Action |
|---|---|
| `Esc`, `m` | Toggle main menu |
| `F2`, `o` | Open options screen |
| `F1`, `?`, `h` (or `H` if `vim_keys` steals `h`) | Show in-app help |
| `p` | Cycle layout presets forward |
| `Shift+p` | Cycle layout presets backward |
| `+`, `-` | Add/subtract 100ms from the update interval |
| `Ctrl+r` | Reload config file from disk (no restart needed) |
| `Ctrl+z` | Suspend btop to background |
| `q`, `Ctrl+c` | Quit |
| Mouse click | Select in process list / press buttons |
| Mouse scroll | Scroll whatever list/text is under the cursor |

## Process list (PROC box)

| Key | Action |
|---|---|
| `Up`, `Down` | Move selection |
| `Pg Up`, `Pg Down` | Jump one page |
| `Home`, `End` | Jump to first/last page |
| `Left`, `Right` | Change sort column |
| `r` | Reverse sort order |
| `c` | Toggle per-core CPU% for processes |
| `e` | Toggle tree view |
| `Space` (on a process) | Expand/collapse that process in tree view |
| `C` | Expand/collapse a process's children |
| `E` | Expand/collapse *all* processes in tree view |
| `%` | Toggle memory display mode (percent vs. bytes) |
| `F` | Follow selected process (keeps it in view as list updates) |
| `u` | Pause the process list |
| `f`, `/` | Enter a filter (prefix with `!` for regex) |
| `Delete` | Clear the current filter |
| `Enter` | Open detailed info for the selected process |

### Acting on a selected process

| Key | Action |
|---|---|
| `t` | Terminate (SIGTERM, 15) |
| `k` (or `Shift+K`, see below) | Kill (SIGKILL, 9) |
| `s` | Pick a specific signal to send |
| `N` | Set a new nice value |
| `+`, `-` | Expand/collapse that process in tree view |

## Network box (NET)

| Key | Action |
|---|---|
| `b`, `n` | Previous/next network interface |
| `z` | Reset totals for the current interface |
| `a` | Toggle graph auto-scaling |
| `y` | Toggle synced scaling between up/down graphs |

## Disks (in the MEM box)

| Key | Action |
|---|---|
| `d` | Toggle disk view inside the MEM box |
| `i` | Toggle I/O mode (big read/write graphs instead of usage meters) |

## Vim keys caveat

With `vim_keys = true`, plain `h j k l g G` move around lists (left/down/
up/right/top/bottom). `h` and `k` also have unrelated meanings above
(help, kill) — btop resolves the clash by keeping the plain letter as the
vim navigation key and moving help/kill to **`Shift+H`** / **`Shift+K`**.

## Presets

`presets` in `btop.conf` defines alternate box layouts, cycled with `p` /
`Shift+p`. Preset `0` is always "all boxes, default settings" and isn't
listed in the config. Ours adds three more:

1. `cpu:1:default,proc:0:default` — CPU (alt position) + process list only.
2. `cpu:0:default,mem:0:default,net:0:default` — CPU + memory + network,
   no process list.
3. `cpu:0:block,net:0:tty` — just CPU and network, using the `block` and
   `tty` graph symbols instead of braille (useful over a laggy SSH link or
   a font without braille glyphs).

## Useful stuff

- **Filter fast:** `f` or `/`, type a substring, `Enter`. Prefix with `!`
  to filter by regex instead.
- **Tree view for parent/child relationships:** `e` toggles it, `Space`
  expands/collapses one branch, `E` expands/collapses everything.
- **Reload config without restarting:** edit `btop.conf` (or the theme
  file) in another pane, then hit `Ctrl+r` in btop to pick it up live.
- **Per-core CPU% on processes:** `c` — helpful for spotting a
  single-threaded process pegging one core on an otherwise idle machine.
- **Following a spawned process:** select it, press `F` — keeps it
  in view even as the sorted list reorders around it.
- **GPU box:** shown automatically when GPU stats are detected
  (`show_gpu_info = "Auto"`); toggle manually with `5`.
