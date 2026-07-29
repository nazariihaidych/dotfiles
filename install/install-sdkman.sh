#!/bin/bash
set -euo pipefail

SDKMAN_DIR="${SDKMAN_DIR:-$HOME/.sdkman}"

if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
  echo "SDKMAN already installed."
else
  echo "Installing SDKMAN..."
  # SDKMAN's installer requires Bash 4+, but macOS ships an ancient /bin/bash
  # 3.2 (frozen at GPLv2) that can still shadow Homebrew's bash depending on
  # PATH order. Install Homebrew's bash and invoke it explicitly rather than
  # trusting the ambient `bash` on PATH.
  if ! command -v brew &>/dev/null; then
    echo "Homebrew is not installed. Run install-homebrew.sh first."
    exit 1
  fi
  brew list bash &>/dev/null || brew install bash
  curl -s "https://get.sdkman.io" | "$(brew --prefix bash)/bin/bash"
fi

echo "Open a new terminal and run 'sdk install java' (or kotlin/gradle/maven/etc.) to install a JVM SDK."
