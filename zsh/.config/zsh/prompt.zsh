# ~/.config/zsh/prompt.zsh
# Loads the starship prompt.

# Prevent Python's virtualenv from prepending "(venv)" to the prompt.
# Starship handles virtualenv display itself via its [python] module.
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Initialise starship for zsh.
# This replaces zsh's built-in PS1/PROMPT with starship's dynamic prompt.
# Install: brew install starship
# Docs:    https://starship.rs
eval "$(starship init zsh)"
