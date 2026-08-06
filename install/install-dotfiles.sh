#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

if ! command -v stow &>/dev/null; then
  echo "stow is not installed. Run install-stow.sh first."
  exit 1
fi

PACKAGES=(zsh git tmux ghostty kitty nvim nvim_LazyVim yazi herdr claude btop lazydocker lazygit)

for pkg in "${PACKAGES[@]}"; do
  echo "Stowing ${pkg}..."
  case "$pkg" in
  claude)
    # ~/.claude is Claude Code's whole live state directory (history,
    # sessions, auth-adjacent files, other tools' hooks) — this repo only
    # tracks statusline-command.sh out of it. --no-folding keeps ~/.claude
    # itself a real directory with just that one file symlinked in, instead
    # of stow's default of folding the whole directory into a single
    # symlink (which would point ALL of Claude Code's live state at this
    # git repo).
    stow --dir="$REPO_DIR" --restow --target="$HOME" --no-folding "$pkg"
    ;;
  zsh | herdr)
    # Same folding hazard as claude above: zsh's plugins.zsh git-clones
    # into $ZDOTDIR/plugins on first run, and herdr writes its own
    # .plugins.lock — both are runtime state, not repo content. Folding
    # would point those live-written paths at this git repo instead of a
    # real ~/.config/{zsh,herdr} directory. --no-folding keeps only the
    # tracked files symlinked.
    stow --dir="$REPO_DIR" --restow --target="$HOME" --no-folding "$pkg"
    ;;
  *)
    stow --dir="$REPO_DIR" --restow --target="$HOME" "$pkg"
    ;;
  esac
done

echo "All packages stowed."
