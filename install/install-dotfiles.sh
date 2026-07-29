#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

if ! command -v stow &>/dev/null; then
  echo "stow is not installed. Run install-stow.sh first."
  exit 1
fi

PACKAGES=(zsh git tmux ghostty kitty nvim nvim_LazyVim yazi herdr claude)

for pkg in "${PACKAGES[@]}"; do
  echo "Stowing ${pkg}..."
  if [[ "$pkg" == "claude" ]]; then
    # ~/.claude is Claude Code's whole live state directory (history,
    # sessions, auth-adjacent files, other tools' hooks) — this repo only
    # tracks statusline-command.sh out of it. --no-folding keeps ~/.claude
    # itself a real directory with just that one file symlinked in, instead
    # of stow's default of folding the whole directory into a single
    # symlink (which would point ALL of Claude Code's live state at this
    # git repo).
    stow --dir="$REPO_DIR" --restow --target="$HOME" --no-folding "$pkg"
  else
    stow --dir="$REPO_DIR" --restow --target="$HOME" "$pkg"
  fi
done

echo "All packages stowed."
