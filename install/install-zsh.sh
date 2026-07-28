#!/bin/bash
set -euo pipefail

if ! command -v brew &>/dev/null; then
  echo "Homebrew is not installed. Run install-homebrew.sh first."
  exit 1
fi

BREW_ZSH="$(brew --prefix zsh 2>/dev/null)/bin/zsh"

if [[ ! -x "$BREW_ZSH" ]]; then
  echo "Homebrew zsh not found. Run install-brewfile.sh first."
  exit 1
fi

if [[ "$SHELL" == "$BREW_ZSH" ]]; then
  echo "Homebrew zsh is already the default shell."
  exit 0
fi

if ! grep -qF "$BREW_ZSH" /etc/shells; then
  echo "Registering $BREW_ZSH in /etc/shells (requires sudo)..."
  echo "$BREW_ZSH" | sudo tee -a /etc/shells >/dev/null
fi

chsh -s "$BREW_ZSH"
echo "Default shell set to $BREW_ZSH. Log out and back in for it to take effect."
