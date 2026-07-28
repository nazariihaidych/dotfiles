#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Install everything in order. Each script is idempotent — safe to re-run
# install-all.sh after it fails partway through.
. ./install-homebrew.sh
. ./install-stow.sh
. ./install-brewfile.sh
. ./install-dotfiles.sh
. ./install-zsh.sh
. ./install-macos-defaults.sh
. ./install-nvm.sh
. ./install-ruby.sh
. ./install-sdkman.sh

echo
echo "Setup complete. Open a new terminal window for the zsh config to take effect."
