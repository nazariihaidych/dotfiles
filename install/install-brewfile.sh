#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

if ! command -v brew &>/dev/null; then
  echo "Homebrew is not installed. Run install-homebrew.sh first."
  exit 1
fi

# Third-party taps our Brewfile pulls formulae from (keep in sync with any
# `tap "..."` lines in ../Brewfile). Homebrew blocks loading formulae from a
# tap it hasn't seen trusted before, so pre-trust each one we deliberately
# chose to include — this isn't a blanket "trust everything" policy, only
# the specific taps already vetted and listed in this repo.
THIRD_PARTY_TAPS=(kopecmaciej/vi-mongo)

for tap in "${THIRD_PARTY_TAPS[@]}"; do
  brew tap "$tap" &>/dev/null || true
  brew trust "$tap" 2>/dev/null || echo "  (brew trust unavailable or already trusted for $tap — continuing)"
done

echo "Installing formulae, casks, and Mac App Store apps from Brewfile..."
echo "(mas entries require being signed into the App Store — sign in first if this is a fresh Mac)"
brew bundle --verbose --file="$REPO_DIR/Brewfile"
