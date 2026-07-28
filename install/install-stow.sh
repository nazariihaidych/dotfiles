#!/bin/bash
set -euo pipefail

if command -v stow &>/dev/null; then
  echo "stow already installed."
else
  echo "Installing GNU Stow..."
  brew install stow
fi
