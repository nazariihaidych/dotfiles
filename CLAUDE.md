# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal macOS dotfiles. Homebrew installs packages/apps, [GNU Stow](https://www.gnu.org/software/stow/)
symlinks config files into `$HOME`, `install/install-all.sh` bootstraps a
new Mac end-to-end. There is no build step and no test suite — validation is
syntax-checking shell/zsh scripts and dry-running `stow`.

## Commands

```sh
# Syntax-check a shell script before committing changes to install/
bash -n install/install-foo.sh

# Syntax-check a zsh module before committing changes to zsh/.config/zsh/
zsh -n zsh/.config/zsh/.zshrc

# Validate the Brewfile parses without installing anything
brew bundle list --file=Brewfile

# Dry-run stow for one package (see what it would link/conflict on)
stow --target="$HOME" --simulate --verbose=1 <package>

# Actually (re)link one package after editing its files
stow --target="$HOME" --restow <package>

# Full bootstrap on a fresh Mac (Homebrew, Brewfile, stow all packages,
# shell, nvm, rbenv, SDKMAN) — safe to re-run, each step is idempotent
cd install && ./install-all.sh
```

Never test `stow` against the live `$HOME` when the target files already
exist as real (non-symlink) files — it will correctly refuse to overwrite
them. Use a scratch directory (`stow --target=/tmp/scratch-home ...`) to
verify a package's structure instead.

## Architecture

**Every top-level directory except `install/` and `references/` is a Stow
package.** A package's contents mirror `$HOME` exactly — `nvim/.config/nvim/`
becomes `~/.config/nvim` when stowed. There is no build/render step between
this repo and the deployed dotfiles; the files here *are* the files that end
up (symlinked) in `$HOME`. When adding a new tool's config, create
`newpkg/.config/newtool/...` and add `newpkg` to the `PACKAGES` array in
`install/install-dotfiles.sh` — that array is the single source of truth for
which packages get stowed on a fresh install.

**`install/install-all.sh` is a fixed-order pipeline**, not a task runner —
it sources each `install-*.sh` script in sequence (Homebrew → stow →
Brewfile → dotfiles/stow → default shell → nvm → rbenv/ruby → SDKMAN).
Each script individually checks `command -v` / file existence before acting,
so re-running `install-all.sh` after a partial failure is safe. Keep new
install steps in their own script and idempotent by the same convention
rather than growing `install-all.sh` itself.

**The zsh config (`zsh/.config/zsh/`) is a framework-free setup based on
[radleylewis/zsh](https://github.com/radleylewis/zsh)** — no Oh My Zsh, no
third-party plugin manager. `.zshrc` sources its modules in a fixed order
(`fzf.zsh` → `aliases.zsh` → `aliases-local.zsh` if present → `bindings.zsh`
→ `plugins.zsh` → `prompt.zsh`); `plugins.zsh` git-clones its 4 plugins into
`$ZDOTDIR/plugins/` on first run rather than depending on a plugin manager.
`~/.zshenv` (the one file that lives directly in `$HOME`, at `zsh/.zshenv`)
does nothing but set `ZDOTDIR=$HOME/.config/zsh` — everything else,
including the *real* `.zshenv`, lives under `zsh/.config/zsh/`.

**`aliases-local.zsh` is the pattern for machine/account-specific config that
must never be committed**: it's listed explicitly in `.gitignore` (not a
directory-wide ignore), and `.zshrc` guards the `source` with a
`[[ -f ... ]]` check so a fresh clone works before that file is recreated by
hand. Follow this same pattern (per-file gitignore entry + existence-guarded
source) for any other config that needs machine-specific secrets or paths.

**Neovim has two parallel configs switched via `NVIM_APPNAME`**, not a
single config with conditionals: `nvim/` (main) and `nvim_LazyVim/`
(LazyVim-based). The `nvimmain`/`nvimown` aliases in `aliases.zsh` just
export `NVIM_APPNAME`; `.zshrc` sets the default. Treat them as fully
independent Stow packages/configs, not variants of one.

**Deliberate deviations from each tool's default location**, made when
migrating from the previous machine (see the README's "Notes on choices"
section for the reasoning): git config lives only at the XDG path
(`~/.config/git/config`, no `~/.gitconfig`); tmux config lives at
`~/.config/tmux/tmux.conf` (XDG, requires tmux ≥ 3.1) instead of
`~/.tmux.conf`. Don't reintroduce the legacy paths.

**`Brewfile` is generated from a real machine's installed state**
(`brew leaves` + `brew list --cask` + `mas list`), not curated from scratch —
when adding entries, prefer verifying the cask/formula token actually exists
(`brew info --cask <token>`) over guessing, since Homebrew tokens don't
always match app names.

**`references/` is read-only research material**, gitignored and never
touched by `stow` or the install scripts — it holds the source configs this
repo was built from (a previous dotfiles repo, an omarchy-based Linux setup,
a standalone zsh config project). Don't treat it as live config.
