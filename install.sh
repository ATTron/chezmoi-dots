#!/bin/bash
set -e

echo "All Done!"

echo "Installing dependencies..."
sudo apt-get update && sudo apt-get install -y curl git ansible

echo "Installing chezmoi..."
curl -sfL https://github.com/twpayne/chezmoi/releases/download/v2.25.0/chezmoi_2.25.0_linux_amd64.tar.gz | sudo tar xz -C /usr/local/bin

chezmoi --version

echo "Creating directory for chezmoi state..."
mkdir -p ~/.local/share/chezmoi

echo "Initializing chezmoi from Git repository..."
chezmoi init --apply git@github.com:ATTron/chezmoi-dots.git
