# ~/.config/zsh/.zshrc
# Main interactive shell config. Loaded only for interactive shells.
# Non-interactive shells (scripts) only read .zshenv.

# =========================================================
# History
# =========================================================

# File where history is persisted between sessions.
# Using XDG_STATE_HOME keeps it out of $HOME.
HISTFILE="$XDG_STATE_HOME/zsh/history"

# zsh won't create missing parent directories for HISTFILE — without this
# it silently never persists history at all.
[[ -d "$XDG_STATE_HOME/zsh" ]] || mkdir -p "$XDG_STATE_HOME/zsh"

# How many entries to keep in memory during the session.
HISTSIZE=100000

# How many entries to persist to HISTFILE on disk.
SAVEHIST=100000

# Append to history file instead of overwriting it on exit.
setopt APPEND_HISTORY

# All open shells share the same history in real time.
setopt SHARE_HISTORY

# Don't record a command if it's identical to the previous one.
setopt HIST_IGNORE_DUPS

# Don't record commands that start with a space (useful for secrets).
setopt HIST_IGNORE_SPACE

# When the history file is full, expire duplicates first.
setopt HIST_EXPIRE_DUPS_FIRST

# Don't show duplicates when searching history with Ctrl+R or arrow keys.
setopt HIST_FIND_NO_DUPS

# =========================================================
# Shell behaviour
# =========================================================

# Type a directory name alone to cd into it (no need to type "cd").
setopt AUTOCD

# Silence all bell sounds (terminal bell, completion bell, etc.).
setopt NOBEEP

# Sort file10 after file9, not after file1 (numeric glob sorting).
setopt NUMERIC_GLOB_SORT

# =========================================================
# Smart directory navigation (zoxide)
# =========================================================

# zoxide is a smarter cd: remembers your most-visited dirs.
# Usage: z foo  ->  jumps to the most-frecent dir matching "foo"
# Install: brew install zoxide
eval "$(zoxide init zsh)"

# =========================================================
# Completion
# =========================================================

# Load zsh's completion system (must be done before compinit).
autoload -Uz compinit

# Initialize completions; -d specifies where to cache the dump file.
# The cache file speeds up subsequent shell startups.
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

# Show a navigable menu when there are multiple completion matches.
# Use arrow keys or Tab to move through the menu.
zstyle ':completion:*' menu select

# Case-insensitive completion: typing "doc" can complete to "Documents".
# m:{a-z}={A-Za-z} means lowercase input matches both upper and lowercase.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# =========================================================
# Fuzzy finder (fzf) — macOS Apple Silicon only
# =========================================================

# Sources fzf's shell integration from Homebrew's prefix.
# key-bindings.zsh  -> Ctrl+R (history), Ctrl+T (file), Alt+C (cd)
# completion.zsh    -> ** trigger for path/process completion
if [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

# Fallback for Intel Macs (Homebrew at /usr/local)
if [[ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
  source /usr/local/opt/fzf/shell/completion.zsh
fi

# =========================================================
# Modular config files
# =========================================================

# fzf options and custom fzf functions
source "$ZDOTDIR/fzf.zsh"

# Shell aliases (ls -> eza, cat -> bat, vim -> nvim, etc.)
source "$ZDOTDIR/aliases.zsh"

# Machine-specific aliases, gitignored — only sourced if present (see aliases-local.zsh)
[[ -f "$ZDOTDIR/aliases-local.zsh" ]] && source "$ZDOTDIR/aliases-local.zsh"

# Custom keybindings (Ctrl+F, Ctrl+arrows, history search)
source "$ZDOTDIR/bindings.zsh"

# Plugins (auto-installs them on first run via git clone)
source "$ZDOTDIR/plugins.zsh"

# Prompt (starship)
source "$ZDOTDIR/prompt.zsh"

# =========================================================
# Neovim config selection
# =========================================================

# Sets the active neovim config directory. nvim reads $NVIM_APPNAME to choose
# which folder under ~/.config/ to use as its config root.
# Switch with the nvimmain / nvimown aliases defined in aliases.zsh.
export NVIM_APPNAME=nvim

# =========================================================
# Node / NVM
# =========================================================

# NVM_DIR is where nvm stores Node versions.
# Install nvm: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"

# Load nvm itself (lazy-loads; does nothing if not installed)
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

# Load nvm's bash tab-completion
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# =========================================================
# Ruby / rbenv
# =========================================================

# rbenv manages multiple Ruby versions (like nvm for Ruby).
# Install: brew install rbenv ruby-build
# Then: rbenv install <version>  and  rbenv global <version>
if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init - zsh)"
  # rbenv shims must come after rbenv init so the shim dir takes precedence
  export PATH="$HOME/.rbenv/shims:$PATH"
fi

# =========================================================
# SDKMAN (Java / Kotlin / Groovy / Scala / etc.)
# =========================================================

# SDKMAN manages JVM-ecosystem SDKs — Java, Kotlin, Gradle, Maven, etc.
# Install: curl -s "https://get.sdkman.io" | bash
# Usage:  sdk install java   sdk use java 21   sdk list java
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# =========================================================
# Colored man pages
# =========================================================

# LESS_TERMCAP_* variables control how man pages are rendered in less.
# These only apply when MANPAGER is set to 'less' (not bat).
# If bat is installed, .zshenv sets MANPAGER=bat which overrides these.

# mb: start blinking — shown as bold red (most terminals ignore blink)
export LESS_TERMCAP_mb=$'\e[1;31m'
# md: start bold — used for section headers
export LESS_TERMCAP_md=$'\e[1;31m'
# me: end all formatting (bold/blink/etc.)
export LESS_TERMCAP_me=$'\e[0m'
# se: end standout mode (end of search highlight)
export LESS_TERMCAP_se=$'\e[0m'
# so: start standout — search results: bold yellow on blue background
export LESS_TERMCAP_so=$'\e[1;33;44m'
# ue: end underline
export LESS_TERMCAP_ue=$'\e[0m'
# us: start underline — bold green
export LESS_TERMCAP_us=$'\e[4;1;32m'
# mr: reverse-video mode
export LESS_TERMCAP_mr=$'\e[7m'
# mh: dim/half-bright mode
export LESS_TERMCAP_mh=$'\e[2m'
