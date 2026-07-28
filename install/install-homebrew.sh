#!/bin/bash
set -euo pipefail

if command -v brew &>/dev/null; then
  echo "Homebrew already installed."
else
  echo "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Apple Silicon: brew installs to /opt/homebrew, which isn't on PATH yet in this shell.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

echo "Homebrew ready: $(brew --version | head -1)"
