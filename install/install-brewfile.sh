#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

if ! command -v brew &>/dev/null; then
  echo "Homebrew is not installed. Run install-homebrew.sh first."
  exit 1
fi

echo "Installing formulae, casks, and Mac App Store apps from Brewfile..."
echo "(mas entries require being signed into the App Store — sign in first if this is a fresh Mac)"
brew bundle --file="$REPO_DIR/Brewfile"
