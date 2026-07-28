# ~/.config/zsh/aliases.zsh
# Shell aliases — loaded by .zshrc on every interactive session.

# =========================================================
# File listing  (eza — a modern replacement for ls)
# Install: brew install eza
# =========================================================

# Basic listing with icons (requires a Nerd Font in terminal)
alias ls='eza --icons'

# Long listing: permissions, owner, size, date, git status, icons
alias ll='eza -lh --icons --git'

# Long listing including hidden files (dot-files)
alias la='eza -lah --icons --git'

# Recursive tree view of the current directory
alias tree='eza --tree --icons'

# Reuse zsh's built-in ls completion rules for eza.
# Without this, eza gets no filename completion.
compdef eza=ls

# =========================================================
# File viewing  (bat — a syntax-highlighted cat)
# Install: brew install bat
# =========================================================

# Replace cat with bat. bat adds line numbers, syntax colors, git diff markers.
# Pass --plain or -P to bat if you need plain output.
alias cat='bat'

# =========================================================
# Core utilities
# =========================================================

# Replace grep with ripgrep: faster, respects .gitignore, shows colors.
# Install: brew install ripgrep
alias grep='rg --color=auto'

# Colorize diff output (built into macOS diff / GNU diffutils)
alias diff='diff --color=auto'

# Human-readable disk usage (shows GB/MB instead of raw bytes)
alias df='df -h'

# =========================================================
# Navigation
# =========================================================

# 'cd -' jumps back to the previous directory (like a browser Back button).
# The leading '--' stops zsh from parsing '-' as a flag.
alias -- -='cd -'

# =========================================================
# Editor
# =========================================================

# Alias vim to neovim so muscle memory still works.
# Install: brew install neovim
alias vim='nvim'

# =========================================================
# Git
# =========================================================

# Short status — just the file list, no verbose prose
alias gs="git status --short"

# Show unstaged changes (what you haven't added yet)
alias dg="git diff"

# Stage files — use: ga . or ga <file>
alias ga="git add"

# Commit — use: gc -m "message" or gc --amend
alias gc="git commit"

# Pull latest from remote
alias gp="git pull"

# Push to remote (capital P to avoid accidental pushes)
alias gP="git push"

# Graph log: coloured, shows all branches with author and relative time
alias gl="git log --graph --all --pretty=format:'%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n'"

# List branches sorted by most recently committed
alias gb="git branch"

# Init a new repo in the current directory
alias gi="git init"

# Clone a repo: gcl <url>
alias gcl="git clone"

# Pretty git log (verbose, uses less pager). -F: quit if fits on screen; -X: no clear on exit.
alias glog='PAGER="less -F -X" git log'

# Full decorated graph log — all branches, one line each.
alias gadog='PAGER="less -F -X" git log --all --decorate --oneline --graph'

# =========================================================
# Config editing shortcuts
# =========================================================

# Open this zsh config in neovim
alias zshconfig="nvim ~/.config/zsh/.zshrc"

# =========================================================
# Neovim config switching
# =========================================================
# Neovim supports multiple named configs via NVIM_APPNAME.
# ~/.config/nvim        -> main config
# ~/.config/nvim_LazyVim -> LazyVim-based config

# Switch active config to the main nvim setup
alias nvimmain="export NVIM_APPNAME=nvim"

# Switch active config to the LazyVim setup
alias nvimown="export NVIM_APPNAME=nvim_LazyVim"

# =========================================================
# Docker
# =========================================================

# Formatted docker ps: show only name, status and ports (much more readable than default)
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'

# Rebuild a single service image and restart only that container (not its dependencies).
# Useful when you change the Dockerfile or app code but don't want to restart the DB, etc.
alias dcompose-build-no-deps="docker compose up -d --build --force-recreate --no-deps"

# =========================================================
# macOS specific
# =========================================================

# Flush the DNS resolver cache (useful after editing /etc/hosts)
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

# Open the current directory in Finder
alias finder='open .'

# Show/hide hidden files in Finder
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'

# Lock the screen
alias lock='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'

# Copy current directory path to clipboard
alias cpwd='pwd | pbcopy'
