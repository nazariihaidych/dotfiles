# ~/.config/zsh/bindings.zsh
# Custom keybindings, loaded by .zshrc.
# NOTE: zsh-vi-mode resets ALL bindings when it initialises,
# so custom bindings MUST be placed inside the zvm_after_init() hook.

# =========================================================
# Vi mode cursor shapes
# =========================================================

# In INSERT mode: show a blinking/steady beam (thin vertical line)
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM

# In NORMAL (command) mode: show a block cursor
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK

# In VISUAL mode: show a block cursor
ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK

# =========================================================
# Vi mode visual selection highlight
# =========================================================

# Disable background/foreground colour for visual selection.
# Set to a colour string (e.g. "#3b4252") to enable highlighting.
ZVM_VI_HIGHLIGHT_BACKGROUND=none
ZVM_VI_HIGHLIGHT_FOREGROUND=none
ZVM_VI_HIGHLIGHT_EXTRASTYLE=none

# =========================================================
# Keybindings (registered after zsh-vi-mode initialises)
# =========================================================

zvm_after_init() {
  # Ctrl+Right  ->  move forward one word
  # ^[[1;5C is the ANSI escape sequence your terminal sends for Ctrl+Right.
  # Run: cat -v, then press Ctrl+Right to find your terminal's sequence.
  bindkey '^[[1;5C' forward-word

  # Ctrl+Left  ->  move backward one word
  bindkey '^[[1;5D' backward-word

  # Ctrl+F  ->  open fzf file picker (hidden files excluded)
  # _fzf_file_no_hidden is defined in fzf.zsh
  bindkey '^F' _fzf_file_no_hidden

  # Ctrl+\  ->  toggle zsh-autosuggestions on/off
  # Handy when recording screencasts so suggestions don't clutter the view.
  bindkey '^\' autosuggest-toggle

  # Up arrow   ->  search history backward by the prefix you already typed
  # Down arrow ->  search history forward by prefix
  # Provided by the zsh-history-substring-search plugin.
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
}
