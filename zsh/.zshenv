# The only zsh file that lives directly in $HOME.
# Everything else lives in ~/.config/zsh/ — see that .zshenv for why.
#
# zsh reads $ZDOTDIR/.zshenv using ZDOTDIR's value *before* this file runs
# (i.e. unset, so $HOME) — setting ZDOTDIR here does NOT make zsh re-read
# .zshenv from the new location the way it does for .zprofile/.zshrc/.zlogin.
# So the real .zshenv must be sourced explicitly here, or its exports
# (PATH, XDG vars, etc.) never run.
export ZDOTDIR="$HOME/.config/zsh"
source "$ZDOTDIR/.zshenv"
