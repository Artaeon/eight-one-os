#!/bin/bash
set -e

cd /home/rrl/Projects/arch-lin

# 1. Base Project Setup
git add .gitignore README.md holy-iso/profiledef.sh holy-iso/pacman.conf holy-iso/efiboot/ holy-iso/syslinux/
git commit -m "chore: initial project setup with README and archiso releng baseline" || true

# 2. Package Selection
git add holy-iso/packages.x86_64
git commit -m "feat: configure developer packages (hyprland, neovim, alacritty, tools)" || true

# 3. Base Live User Setup
git add holy-iso/airootfs/root/customize_airootfs.sh holy-iso/airootfs/etc/systemd/ holy-iso/airootfs/etc/sudoers.d/
git commit -m "feat(system): setup passwordless auto-login for holy live user" || true

# 4. Hyprland Base
git add holy-iso/airootfs/etc/skel/.config/hypr/hyprland.conf holy-iso/airootfs/usr/local/bin/start-hyprland
git commit -m "feat(wm): comprehensive hyprland config with 50+ keybindings and qemu wrapper" || true

# 5. Holy UI/Theme (Waybar, Hyprpaper, Hyprlock, Alacritty, Mako)
git add holy-iso/airootfs/etc/skel/wallpaper.png holy-iso/airootfs/etc/skel/.config/hypr/hyprpaper.conf holy-iso/airootfs/etc/skel/.config/hypr/hyprlock.conf holy-iso/airootfs/etc/skel/.config/waybar/ holy-iso/airootfs/etc/skel/.config/alacritty/ holy-iso/airootfs/etc/skel/.config/mako/
git commit -m "style: implement EIGHT.ONE Gold & Black aesthetic and glassmorphism UI" || true

# 6. Shell & IDE Configuration
git add holy-iso/airootfs/etc/skel/.zshrc holy-iso/airootfs/root/.zshrc holy-iso/airootfs/etc/skel/.config/nvim/
git commit -m "feat(dev): configure LazyVim IDE and Zsh prompt with 8.1 Infinity Logo" || true

# 7. Holy Tools
git add holy-iso/airootfs/usr/local/bin/holy-*
git commit -m "feat(tools): add monastic distraction blocker, AI assistant, and bible integration" || true
