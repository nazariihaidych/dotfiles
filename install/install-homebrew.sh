#!/bin/bash
set -euo pipefail

if command -v brew &>/dev/null; then
  echo "Homebrew already installed."
else
  # Deliberately not NONINTERACTIVE=1: Homebrew's installer does its own
  # `sudo -v` when run interactively, which prompts for your password
  # normally. In NONINTERACTIVE mode that check becomes non-interactive-only
  # (`sudo -n`) and aborts outright without a pre-cached credential — even
  # for a genuine admin account. Letting it run interactively here means one
  # expected password prompt, no extra plumbing.
  echo "Installing Homebrew (you'll be asked for your admin password once)..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Apple Silicon: brew installs to /opt/homebrew, which isn't on PATH yet in this shell.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

echo "Homebrew ready: $(brew --version | head -1)"
