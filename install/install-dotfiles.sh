#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

if ! command -v stow &>/dev/null; then
  echo "stow is not installed. Run install-stow.sh first."
  exit 1
fi

PACKAGES=(zsh git tmux ghostty kitty nvim nvim_LazyVim yazi herdr)

cd "$REPO_DIR"

for pkg in "${PACKAGES[@]}"; do
  echo "Stowing ${pkg}..."
  stow --restow --target="$HOME" "$pkg"
done

echo "All packages stowed."
