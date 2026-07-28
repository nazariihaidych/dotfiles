#!/bin/bash
set -euo pipefail

NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  echo "nvm already installed."
else
  echo "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

# shellcheck disable=SC1091
source "$NVM_DIR/nvm.sh"

if [[ -d "$NVM_DIR/versions/node" ]] && [[ -n "$(ls -A "$NVM_DIR/versions/node" 2>/dev/null)" ]]; then
  echo "A Node version is already installed."
else
  echo "Installing latest LTS Node..."
  nvm install --lts
  nvm alias default lts/*
fi
