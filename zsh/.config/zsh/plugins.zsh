# ~/.config/zsh/plugins.zsh
# Lightweight plugin manager — no third-party tool required.
# Plugins are git-cloned into $ZPLUGINDIR on first launch, then sourced.

# =========================================================
# Plugin directory
# =========================================================

# Store plugins next to the zsh config (inside $ZDOTDIR).
# Falls back to ~/.config/zsh/plugins if $ZDOTDIR is unset.
ZPLUGINDIR="${ZDOTDIR:-$HOME/.config/zsh}/plugins"

# =========================================================
# _zplugin_load  —  install + source a plugin
# =========================================================

# Usage: _zplugin_load <github-user> <repo-name>
#
# If the plugin directory does not exist:
#   1. Creates $ZPLUGINDIR
#   2. Shallow-clones (--depth=1) the repo to save disk space
# Then sources <repo-name>.plugin.zsh (the standard plugin entry point).
_zplugin_load() {
  local plugin_path="${ZPLUGINDIR}/${2}"
  if [[ ! -d "$plugin_path" ]]; then
    mkdir -p "$ZPLUGINDIR"
    echo "Installing ${2}..."
    git clone --depth=1 "https://github.com/${1}/${2}" "$plugin_path" \
      || { echo "ERROR: failed to install ${2}" >&2; return 1; }
  fi
  source "${plugin_path}/${2}.plugin.zsh"
}

# =========================================================
# zplugin-update  —  pull latest changes for all plugins
# =========================================================

# Run this manually when you want to update all plugins:
#   zplugin-update
#
# Uses --ff-only to refuse merges (clean fast-forward only).
zplugin-update() {
  local dir
  for dir in "${ZPLUGINDIR}"/*/; do
    echo "Updating ${dir:t}..."
    git -C "$dir" pull --ff-only
  done
}

# =========================================================
# Plugin list
# =========================================================

# zsh-autosuggestions (zsh-users/zsh-autosuggestions)
# Purpose: Fish-style inline suggestions as you type, based on history.
# Accept suggestion: press Right arrow or End key.
_zplugin_load zsh-users zsh-autosuggestions

# zsh-history-substring-search (zsh-users/zsh-history-substring-search)
# Purpose: Press Up/Down arrow to search history entries that START WITH
#          whatever you've already typed — smarter than default history search.
_zplugin_load zsh-users zsh-history-substring-search

# zsh-vi-mode (jeffreytse/zsh-vi-mode)
# Purpose: Full vi keybindings in the shell (Normal/Insert/Visual modes).
# Enter Normal mode: press Escape. Back to Insert: press i or a.
# NOTE: this plugin resets all bindings; use zvm_after_init() in bindings.zsh
#       to add custom bindings that survive the reset.
_zplugin_load jeffreytse zsh-vi-mode

# fast-syntax-highlighting (zdharma-continuum/fast-syntax-highlighting)
# Purpose: Colour-codes commands as you type — valid commands are green,
#          invalid ones are red, strings/flags get distinct colours.
# Must be loaded LAST so it can wrap the other plugins.
_zplugin_load zdharma-continuum fast-syntax-highlighting
