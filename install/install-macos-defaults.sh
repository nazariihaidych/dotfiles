#!/bin/bash
set -euo pipefail

# Applies this Mac's actual Dock/Finder/appearance settings, captured via
# `defaults read` on 2026-07-29. Not part of install-all.sh on purpose —
# system-level tweaks should be a deliberate, reviewed opt-in, not something
# that runs silently as part of a full bootstrap. Run by hand:
#   ./install-macos-defaults.sh

echo "Applying Dock settings..."
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 42
defaults write com.apple.dock largesize -int 16
defaults write com.apple.dock magnification -bool false
defaults write com.apple.dock orientation -string "bottom"
defaults write com.apple.dock mineffect -string "genie"
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock show-recents -bool true
defaults write com.apple.dock mru-spaces -bool false                     # don't auto-rearrange Spaces by recent use
defaults write com.apple.dock expose-group-apps -bool true               # group windows by application in Mission Control
defaults write com.apple.dock workspaces-auto-swoosh -bool true          # switch to a Space with the app's open windows

echo "Applying window/tiling/Mission Control settings..."
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool true   # hold Option while dragging to tile
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool true          # drag to left/right edge to tile
defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool true       # drag to menu bar to fill screen
defaults write com.apple.spaces spans-displays -bool false               # displays have separate Spaces
defaults write NSGlobalDomain AppleActionOnDoubleClick -string "Fill"    # title bar double-click action
defaults write NSGlobalDomain AppleWindowTabbingMode -string "fullscreen" # prefer tabs when opening documents: In Full Screen
defaults write NSGlobalDomain NSCloseAlwaysConfirmsChanges -bool false   # don't ask to keep changes when closing
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false       # close windows when quitting an app

echo "Applying menu bar settings..."
defaults write NSGlobalDomain _HIHideMenuBar -bool true                  # automatically hide/show the menu bar: Always

echo "Applying Finder settings..."
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"      # column view
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool false
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"      # search the current folder
defaults write com.apple.finder NewWindowTarget -string "PfDo"           # new windows open $HOME
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true

echo "Applying appearance/accent color settings..."
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true
defaults write NSGlobalDomain AppleAquaColorVariant -int 1
defaults write NSGlobalDomain AppleAccentColor -int 6                    # Purple
defaults write NSGlobalDomain AppleHighlightColor -string "0.968627 0.831373 1.000000 Purple"
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"
defaults write NSGlobalDomain AppleScrollerPagingBehavior -bool false    # click in scroll bar: jump to the next page
defaults write NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool false  # superseded by AppleActionOnDoubleClick above, kept in sync
defaults write NSGlobalDomain AppleIconAppearanceTintColor -string "Yellow"  # folder/app icon tint (macOS 26+)

echo "Restarting Dock and Finder..."
killall Dock &>/dev/null || true
killall Finder &>/dev/null || true

echo "Done. Some changes (icon tint, accent color) may need a logout/login to fully apply everywhere."
echo "Not scripted: mouse tracking/scroll/double-click speed and secondary-click mode —"
echo "those live in a per-Bluetooth-device profile, not a generic domain, so set them"
echo "by hand in System Settings > Mouse once your mouse is paired."
echo "Also not scripted: Menu Bar > 'Show menu bar background' (off) and 'Recent"
echo "documents, applications, and servers' (10) — no backing defaults(1) key was"
echo "found for either after searching every domain; set them by hand in"
echo "System Settings > Menu Bar."
