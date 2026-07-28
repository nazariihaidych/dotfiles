#!/bin/bash
set -euo pipefail

if ! command -v rbenv &>/dev/null; then
  echo "rbenv is not installed. Run install-brewfile.sh first."
  exit 1
fi

if [[ -n "$(rbenv versions --bare 2>/dev/null)" ]]; then
  echo "A Ruby version is already installed via rbenv."
  exit 0
fi

LATEST="$(rbenv install -l 2>/dev/null | grep -vE '(-|dev|rc)' | tail -1 | tr -d ' ')"
echo "Installing Ruby ${LATEST} via rbenv (this compiles from source and takes a few minutes)..."
rbenv install "$LATEST"
rbenv global "$LATEST"
