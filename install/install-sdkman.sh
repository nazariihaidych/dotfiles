#!/bin/bash
set -euo pipefail

SDKMAN_DIR="${SDKMAN_DIR:-$HOME/.sdkman}"

if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
  echo "SDKMAN already installed."
else
  echo "Installing SDKMAN..."
  curl -s "https://get.sdkman.io" | bash
fi

echo "Open a new terminal and run 'sdk install java' (or kotlin/gradle/maven/etc.) to install a JVM SDK."
