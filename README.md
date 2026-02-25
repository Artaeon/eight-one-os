<h1 align="center">EIGHT.ONE OS</h1>
<h3 align="center">A keyboard-driven Arch Linux distribution for developers</h3>

<p align="center">
  <img src="https://img.shields.io/badge/Base-Arch%20Linux-1793D1?style=for-the-badge&logo=archlinux&logoColor=white" alt="Arch Linux"/>
  <img src="https://img.shields.io/badge/WM-Hyprland-58E1FF?style=for-the-badge&logo=wayland&logoColor=white" alt="Hyprland"/>
  <img src="https://img.shields.io/badge/Shell-Zsh-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="Zsh"/>
  <img src="https://img.shields.io/badge/License-MIT-D4AF37?style=for-the-badge" alt="MIT"/>
</p>

---

EIGHT.ONE OS is an opinionated Arch Linux distribution built with `archiso`. It ships a complete Hyprland desktop, an AI-integrated IDE, and 21 custom TUI utilities — all configured and themed out of the box. No post-install configuration required.

## Overview

| Component | Choice |
|-----------|--------|
| Compositor | Hyprland (Wayland) |
| Terminal | Kitty |
| Shell | Zsh + Starship prompt |
| Editor | Neovim (LazyVim) + VS Code (EIGHT.ONE Gold) |
| Launcher | Fuzzel |
| Bar | Waybar |
| Notifications | Mako |
| File Manager | Yazi |
| Multiplexer | Zellij / Tmux |
| Lock Screen | Hyprlock |
| Idle Manager | Hypridle |
| Login | greetd (auto-login) |
| Package Manager | pacman (color, parallel downloads) |

## Features

### Desktop Environment
- Unified dark theme with gold accents across GTK3, GTK4, QT5, Kitty, Fuzzel, Mako, and Waybar
- Glassmorphism Waybar with Bluetooth, backlight, recording indicator, and system metrics
- Hyprlock lockscreen with solid dark background
- Hypridle with progressive power saving (dim, lock, display off, suspend)
- Papirus-Dark icon theme, JetBrainsMono Nerd Font

### Developer Toolkit
- **Neovim** with LazyVim — LSP for Go, TypeScript, Python, Rust, Docker, YAML, Tailwind
- **VS Code** with custom EIGHT.ONE Gold theme and 15 pre-configured extensions
- **Git** with delta diff viewer (side-by-side), 15+ aliases
- **Starship** prompt with language version indicators and git status
- Modern CLI: `bat`, `eza`, `fd`, `ripgrep`, `fzf`, `btop`, `dust`, `procs`, `jq`
- Language support: Rust, Python 3, Node.js, GCC/G++

### AI Tools
- **Continue** — open-source AI assistant (connects to Ollama, Claude, GPT)
- **Cline** — Claude-powered AI pair programmer (VS Code extension)
- **Claude Code CLI** — Anthropic's terminal AI coding assistant
- **Gemini CLI** — Google's terminal AI assistant
- **Ollama** — local AI inference (pre-configured, runs as background service)

### Custom Utilities

EIGHT.ONE ships 21 custom scripts accessible from the terminal or the `holy-settings` TUI menu:

| Utility | Description |
|---------|-------------|
| `holy-settings` | Central TUI settings menu |
| `holy-ai` | Local AI assistant via Ollama |
| `holy-bible` | Keyboard-driven Bible search |
| `holy-wifi` | WiFi manager with signal bars (nmcli) |
| `holy-bluetooth` | Bluetooth scan/pair/connect (bluetoothctl) |
| `holy-display` | Monitor resolution/scale/toggle (wlr-randr) |
| `holy-ssh` | SSH key generator with clipboard copy |
| `holy-record` | Screen recording toggle (wf-recorder) |
| `holy-clip` | Clipboard history manager (cliphist) |
| `holy-flow` | Pomodoro-style focus timer |
| `holy-focus` | Distraction blocker (modifies /etc/hosts) |
| `holy-vibes` | Background audio (lo-fi, ambient, chants) |
| `holy-sabbath` | Sunday rest reminder (Waybar module) |
| `holy-intent` | Daily intention setter |
| `holy-dash` | Project dashboard |
| `holy-dev` | Project scaffolding |
| `holy-git` | Git workflow helper |
| `holy-install` | Guided Arch installer |
| `holy-welcome` | First-boot setup wizard |
| `holy-ide` | AI-integrated VS Code with first-run setup |
| `holy-aur` | Self-bootstrapping AUR helper (paru) |
| `eightone-update` | 3-channel system updater (pacman, scripts, AUR) |

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Super + Enter` | Terminal |
| `Super + Space` | App Launcher |
| `Super + Q` | Close Window |
| `Super + L` | Lock Screen |
| `Super + A` | AI Assistant |
| `Super + C` | IDE (VS Code) |
| `Super + B` | Bible Search |
| `Super + T` | Zellij Terminal |
| `Super + E` | File Manager |
| `Super + S` | Screenshot (area) |
| `Super + Shift+S` | Screenshot (full) |
| `Super + Shift+R` | Toggle Recording |
| `Super + V` | Clipboard History |
| `Super + ,` | Settings Menu |
| `Super + D` | Project Dashboard |
| `Super + H/J/K/L` | Focus (vim-style) |
| `Super + 1-9` | Switch Workspace |

## Building

### Prerequisites

An Arch Linux system with `archiso` installed:

```
sudo pacman -S archiso
```

### Local Build

```
cd holy-iso
sudo mkarchiso -v -w /tmp/archiso-work -o ./out .
```

The ISO will be written to `./out/`.

### CI Build

Pushing to `main` triggers a GitHub Actions build that produces the ISO as a downloadable release artifact. See `.github/workflows/build-iso.yml`.

### Testing with QEMU

```
qemu-system-x86_64 -m 4096 -enable-kvm \
  -bios /usr/share/ovmf/OVMF.fd \
  -device virtio-vga-gl -display gtk,gl=on \
  -cdrom out/eight-one-os-*.iso
```

### Writing to USB

```
sudo dd bs=4M if=out/eight-one-os-*.iso of=/dev/sdX status=progress oflag=sync
```

## Project Structure

```
holy-iso/
  packages.x86_64               All packages included in the ISO
  profiledef.sh                  Build profile and file permissions
  airootfs/
    etc/
      greetd/config.toml         Auto-login configuration
      pacman.conf                Pacman with color and parallel downloads
      motd                       Login banner
      skel/
        .config/
          hypr/                  Hyprland, Hyprlock, Hyprpaper, Hypridle
          waybar/                Bar config and glassmorphism CSS
          kitty/                 Terminal theme
          nvim/                  LazyVim IDE configuration
          fuzzel/                Launcher theme
          mako/                  Notification daemon
          zellij/                Multiplexer config
          yazi/                  File manager theme
          gtk-3.0/, gtk-4.0/     GTK dark theme
          qt5ct/                 QT dark theme
          starship.toml          Shell prompt
        .gitconfig               Git aliases and delta config
        .tmux.conf               Tmux gold theme
        .zshrc                   Shell configuration
    usr/local/bin/
      holy-*                     19 custom TUI utilities
```

## License

MIT

---

<p align="center">
  <b>Built by <a href="https://github.com/Artaeon">Artaeon</a></b>
</p>
