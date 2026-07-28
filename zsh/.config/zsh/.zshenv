# ~/.zshenv
# Loaded first, for every shell (interactive, non-interactive, scripts).
# Keep it lean: only environment variables that must be set early.

# ---------- XDG base directories ----------
# Standardizes config/cache/data/state locations under ~/.config, ~/.cache etc.
# instead of scattering dot-files all over $HOME.
export XDG_CONFIG_HOME="$HOME/.config"    # replaces: ~/.somerc  -> ~/.config/sometool/config
export XDG_CACHE_HOME="$HOME/.cache"      # replaces: ~/.sometool_cache -> ~/.cache/sometool/
export XDG_DATA_HOME="$HOME/.local/share" # replaces: ~/.local/sometool -> ~/.local/share/sometool/
export XDG_STATE_HOME="$HOME/.local/state" # for stateful data like shell history

# ---------- zsh config directory ----------
# Tells zsh where to look for .zshrc, .zprofile, etc.
# Without this, zsh reads from $HOME directly.
export ZDOTDIR="$HOME/.config/zsh"

# ---------- Homebrew (Apple Silicon) ----------
# Homebrew lives under /opt/homebrew on Apple Silicon Macs (M1/M2/M3/M4).
# Intel Macs use /usr/local instead — change if needed.
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# ---------- Editor ----------
# Default editor used by git commit, crontab -e, sudoedit, etc.
export EDITOR="nvim"   # neovim — install: brew install neovim
export VISUAL="nvim"   # GUI-capable editor hint (same value is fine)

# ---------- Pager ----------
# Use bat (syntax-highlighted cat) as the man-page renderer.
# Falls back to standard less if bat is not installed.
if command -v bat >/dev/null 2>&1; then
  export MANPAGER="bat -l man -p"  # -l man: treat as man page, -p: plain (no decorations)
fi

# ---------- GPG ----------
# Required so GPG can prompt for a passphrase in the current terminal.
export GPG_TTY=$(tty)

# ---------- Starship ----------
# Tells starship where its config file lives.
# Without this it defaults to ~/.config/starship.toml.
export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"

# ---------- PATH ----------
# Personal binaries / scripts go here — takes priority over system binaries.
export PATH="$HOME/.local/bin:$PATH"
