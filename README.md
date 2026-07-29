# dotfiles

Personal macOS setup: Homebrew for packages/apps, [GNU Stow](https://www.gnu.org/software/stow/)
for dotfiles, one script to bootstrap a new Mac.

## Layout

Each top-level directory is a Stow package. Its contents mirror `$HOME` exactly,
so stowing `nvim/` symlinks `nvim/.config/nvim` to `~/.config/nvim`.

| Package | Symlinks to | Notes |
|---|---|---|
| `zsh/` | `~/.zshenv`, `~/.config/zsh/` | framework-free zsh config (see below) |
| `git/` | `~/.config/git/{config,ignore}` | XDG git config — no `~/.gitconfig` |
| `tmux/` | `~/.config/tmux/tmux.conf` | requires tmux ≥ 3.1 |
| `ghostty/` | `~/.config/ghostty/` | primary terminal |
| `kitty/` | `~/.config/kitty/kitty.conf` | secondary terminal, trimmed to actual overrides |
| `nvim/` | `~/.config/nvim/` | main Neovim config |
| `nvim_LazyVim/` | `~/.config/nvim_LazyVim/` | LazyVim-based config, switch via `NVIM_APPNAME` |
| `yazi/` | `~/.config/yazi/{yazi.toml,theme.toml}` | |
| `herdr/` | `~/.config/herdr/config.toml` | config only — logs/sockets/sessions are runtime state, not tracked |
| `claude/` | `~/.claude/statusline-command.sh` | stowed with `--no-folding` — see below |

`install/` holds the bootstrap scripts (not a Stow package). `references/` is
research material only — gitignored, never touched by Stow.

**`claude/` is a special case:** `~/.claude` is Claude Code's entire live
state directory (history, sessions, other tools' hooks) — this repo only
tracks the statusline script out of it, not the rest. `install-dotfiles.sh`
stows it with `--no-folding` specifically, which keeps `~/.claude` itself a
real directory with just `statusline-command.sh` symlinked in, instead of
stow's default behavior of folding the whole directory into one symlink
(which would point *all* of Claude Code's live state at this git repo).
`~/.claude/settings.json` itself is **not** stowed — it's heavily
auto-managed by other installed apps (writes absolute paths for their own
hooks) — so after stowing, point its `statusLine.command` at
`bash $HOME/.claude/statusline-command.sh` (not a hardcoded `/Users/<old
username>/...` path copied from another machine).

## Bootstrapping a new Mac

```sh
xcode-select --install                 # git, needed to clone this repo
git clone <this-repo-url> ~/dotfiles
cd ~/dotfiles/install
./install-all.sh
```

`install-all.sh` chains these, in order, and each one is safe to re-run:

1. `install-homebrew.sh` — installs Homebrew if missing
2. `install-stow.sh` — `brew install stow`
3. `install-brewfile.sh` — `brew bundle` against `../Brewfile` (CLI tools, GUI apps, Mac App Store apps — sign into the App Store first for the `mas` entries to work)
4. `install-dotfiles.sh` — `stow --restow` every package listed above
5. `install-zsh.sh` — registers Homebrew's zsh in `/etc/shells` and makes it the login shell
6. `install-macos-defaults.sh` — applies this Mac's actual Dock/Finder/window-tiling/Mission Control/menu bar/appearance settings via `defaults write`
7. `install-nvm.sh` — installs [nvm](https://github.com/nvm-sh/nvm) + latest Node LTS
8. `install-ruby.sh` — installs the latest stable Ruby via `rbenv` (already brewed by step 3)
9. `install-sdkman.sh` — installs [SDKMAN](https://sdkman.io) for Java/Kotlin/Gradle/Maven

Run any script standalone if you only need one piece (e.g. re-stowing after
editing a config: `./install-dotfiles.sh`).

**Stow refuses to overwrite real files** — if `~/.config/nvim` (etc.) already
has content on the machine you're running this on, move it aside first
(`mv ~/.config/nvim ~/.config/nvim.bak`) before stowing.

**Deliberately excluded:** corporate-managed tools (VPN clients, Cisco,
GlobalProtect) — install those manually per your IT instructions.

**`install-macos-defaults.sh`** applies Dock/Finder/window-tiling/Mission
Control/menu bar/appearance settings (autohide, icon size, column view,
tiling/edge-drag behavior, title bar double-click action, menu bar
auto-hide, accent color, icon tint, etc.) via `defaults write`. It's part of
`install-all.sh`, but also runs standalone if you just want to reapply it:

```sh
./install-macos-defaults.sh
```

Not captured, deliberately:

- **Pinned Dock apps** — too brittle to script reliably (per-app file bookmarks).
- **Mouse tracking/scroll/double-click speed, secondary-click mode** — these
  live in a per-Bluetooth-device profile keyed to the specific mouse's
  hardware ID, not a generic `defaults` domain. Set by hand in System
  Settings → Mouse once your mouse is paired.
- **Menu Bar → "Show menu bar background" and "Recent documents,
  applications, and servers" count** — no backing `defaults(1)` key exists
  for either after searching every domain on this Mac; likely stored in a
  newer, non-plist-backed settings store. Set by hand in System Settings →
  Menu Bar.

To refresh the script after changing a setting, `defaults read <domain>` the
changed key and update it by hand.

## The zsh config

Framework-free zsh, no Oh My Zsh / Prezto — based on
[radleylewis/zsh](https://github.com/radleylewis/zsh), adapted for Apple
Silicon. Four plugins (`zsh-autosuggestions`, `zsh-history-substring-search`,
`zsh-vi-mode`, `fast-syntax-highlighting`) are git-cloned on first launch by
`plugins.zsh` — no third-party plugin manager. Update them with `zplugin-update`.

Version managers are deliberately mixed on purpose (matches what each
ecosystem does best): **nvm** for Node, **rbenv** for Ruby, **SDKMAN** for the
JVM ecosystem. All three are sourced from `~/.config/zsh/.zshrc`.

Switch the active Neovim config with `nvimmain` (`~/.config/nvim`) /
`nvimown` (`~/.config/nvim_LazyVim`) — both are aliases that just export
`NVIM_APPNAME`.

`aliases-local.zsh` is gitignored and holds machine/account-specific aliases
that don't belong in version control (currently: iCloud Drive shortcuts tied
to this Apple ID). `.zshrc` only sources it if the file exists, so a fresh
clone works fine without it — recreate it by hand on each machine, or copy it
over out-of-band (it's never committed).

See `references/newZshCongigToTry/zsh-main/for-mac-nh/SETUP.md` for the full
walkthrough this config is based on (Nerd Font install, troubleshooting, etc.)
— it predates this repo's Stow-based layout, so ignore its manual `cp` steps.

## Adding a new package

```sh
mkdir -p mypackage/.config/mytool
# put mytool's config at mypackage/.config/mytool/...
stow --target="$HOME" mypackage
```

Then add `mypackage` to the `PACKAGES` array in `install/install-dotfiles.sh`
so fresh installs pick it up automatically.

## Notes on choices made while migrating from the old machine

- **git**: consolidated onto the XDG config (`~/.config/git/config`) and
  dropped the duplicate `~/.gitconfig` that existed on the old machine.
- **tmux**: moved from `~/.tmux.conf` to the XDG path `~/.config/tmux/tmux.conf`
  (supported since tmux 3.1); fixed a leftover `wl-copy` (Wayland/Linux) clipboard
  binding to `pbcopy` (macOS).
- **kitty**: the old `kitty.conf` was the full 3000+ line commented template
  with 5 actual overrides — trimmed to just those 5 lines.
- **tmux plugins**: no TPM usage was found in the old config, so it's not
  installed here. Add `install/install-tmux-tpm.sh` if you start using tmux plugins.
- **Brewfile**: built from `brew leaves` + `brew list --cask` + `mas list` on
  the old machine, plus GUI apps that were present in `/Applications` but
  installed outside Homebrew (now brought under `brew bundle`).
