# Dotfiles

Personal dotfiles managed with [chezmoi](https://chezmoi.io/).

## What's included

- **Neovim** - Lua configuration with modern plugins
- **Tmux** - With TPM and useful plugins
- **Zsh** - Zinit plugin manager and custom aliases
- **Sway/Hyprland/River** - Wayland compositor configs
- **Waybar** - Status bar configuration
- **Ghostty** - Terminal emulator config

## Installation

```bash
# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# Apply dotfiles
chezmoi init --apply https://github.com/ATTron/chezmoi-dots.git
```
