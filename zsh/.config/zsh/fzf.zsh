# ~/.config/zsh/fzf.zsh
# fzf configuration: default commands, UI options, and custom functions.
# Loaded by .zshrc after fzf shell integration is sourced.
# Install fzf: brew install fzf
# Install fd:  brew install fd   (used as the find backend)
# Install bat: brew install bat  (used for file preview)

# =========================================================
# Default find command
# =========================================================

# fd is used instead of the system find command because it:
#   - respects .gitignore by default
#   - is significantly faster on large trees
#   - has cleaner syntax
#
# Flags:
#   --type f           : only list regular files (no dirs, symlinks)
#   --hidden           : include dot-files (e.g. .env, .zshrc)
#   --strip-cwd-prefix : removes the leading "./" from results so paths look cleaner
export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'

# Ctrl+T (file picker) uses the same command as the default.
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# =========================================================
# UI options
# =========================================================

export FZF_DEFAULT_OPTS='
  --height=60%
  --layout=reverse
  --border=rounded
  --prompt="  "
  --pointer="  "
  --preview-window=right:65%:wrap:border-left
'
# --height=60%              : fzf occupies 60% of terminal height (not fullscreen)
# --layout=reverse          : input prompt at top, results below
# --border=rounded          : draws a rounded box around the fzf widget
# --prompt                  : the search prompt text (nerd-font icon here)
# --pointer                 : the cursor indicator next to the selected line
# --preview-window=right... : preview pane on the right at 65% width, with text
#                             wrapping and a left border separator

# =========================================================
# Preview command
# =========================================================

# bat renders a syntax-highlighted preview of the selected file.
#   --color=always           : force ANSI colors even inside a pipe
#   --style=plain,numbers    : show line numbers but no header/grid decorations
#   --line-range=:500        : preview only the first 500 lines (keeps it fast)
#   {}                       : fzf replaces {} with the currently selected file
export _FZF_PREVIEW_CMD='bat --color=always --style=plain,numbers --line-range=:500 {}'

# Apply the preview to Ctrl+T results
export FZF_CTRL_T_OPTS="--preview '$_FZF_PREVIEW_CMD'"

# =========================================================
# Custom widget: Ctrl+F — file picker (hidden files excluded)
# =========================================================

# Like Ctrl+T but strips --hidden from the fd command.
# Useful when you don't want dot-files cluttering the list.
_fzf_file_no_hidden() {
  local cmd result

  # Remove "--hidden " from the default command string
  cmd="${FZF_DEFAULT_COMMAND/--hidden /}"

  # Run fzf; if user picks a file, append it to the left of the cursor (LBUFFER)
  result=$(eval "${cmd:-find . -type f}" | fzf --preview "$_FZF_PREVIEW_CMD") \
    && LBUFFER+="$result"  # LBUFFER = text to the left of the cursor position

  # Redraw the prompt after the fzf overlay closes
  zle reset-prompt
}

# Register the function as a zsh line-editor widget so bindkey can use it
zle -N _fzf_file_no_hidden
