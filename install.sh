#!/bin/bash
set -e

detect_pkg_manager() {
  if command -v pacman &>/dev/null; then
    echo "pacman"
  elif command -v apt-get &>/dev/null; then
    echo "apt"
  else
    echo "unsupported"
  fi
}

PKG_MANAGER=$(detect_pkg_manager)

echo "Detected package manager: $PKG_MANAGER"

echo "Installing dependencies..."
case "$PKG_MANAGER" in
  apt)
    sudo apt-get update && sudo apt-get install -y curl git ansible
    ;;
  pacman)
    sudo pacman -Syu --noconfirm curl git ansible
    ;;
  *)
    echo "Unsupported package manager. Install curl, git, and ansible manually, then re-run."
    exit 1
    ;;
esac

echo "Installing chezmoi..."
curl -sfL https://github.com/twpayne/chezmoi/releases/download/v2.25.0/chezmoi_2.25.0_linux_amd64.tar.gz | sudo tar xz -C /usr/local/bin

chezmoi --version

echo "Creating directory for chezmoi state..."
mkdir -p ~/.local/share/chezmoi

echo "Initializing chezmoi from Git repository..."
chezmoi init --apply git@github.com:ATTron/chezmoi-dots.git

echo "All Done!"
