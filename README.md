<h1 align="center">EIGHT.ONE OS</h1>
<h3 align="center">A keyboard-driven Arch Linux distribution for developers</h3>

<p align="center">
  <img src="https://img.shields.io/badge/Base-Arch%20Linux-1793D1?style=for-the-badge&logo=archlinux&logoColor=white" alt="Arch Linux"/>
  <img src="https://img.shields.io/badge/WM-Hyprland-58E1FF?style=for-the-badge&logo=wayland&logoColor=white" alt="Hyprland"/>
  <img src="https://img.shields.io/badge/Shell-Zsh-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="Zsh"/>
  <img src="https://img.shields.io/badge/License-MIT-D4AF37?style=for-the-badge" alt="MIT"/>
</p>

---

EIGHT.ONE OS is an opinionated Arch Linux distribution built with `archiso`. It ships a complete Hyprland desktop, an AI-integrated IDE, and 26 custom TUI utilities — all configured and themed out of the box. No post-install configuration required. Targets the Matebook (Ryzen 3500U, 8GB RAM) with aggressive power and memory optimization.

## Overview

| Component | Choice |
|-----------|--------|
| Compositor | Hyprland (Wayland) with VFR + VRR |
| Terminal | Kitty |
| Shell | Zsh + Starship prompt |
| Editor | Neovim (LazyVim) + VS Code (EIGHT.ONE Gold) |
| Launcher | Fuzzel |
| Bar | Waybar (glassmorphism, gold accents) |
| Notifications | Mako |
| File Manager | Yazi |
| Multiplexer | Zellij / Tmux |
| Lock Screen | Hyprlock (screenshot blur + gold UI) |
| Idle Manager | Hypridle (dim → lock → DPMS → suspend) |
| Login | greetd (auto-login via start-hyprland) |
| Wallpaper | Hyprpaper (dark + gold geometric) |
| Package Manager | pacman (color, parallel downloads) |

## Features

### Desktop Environment
- Unified dark theme with gold accents (#d4af37) across GTK3, GTK4, QT5, Kitty, Fuzzel, Mako, and Waybar
- Glassmorphism Waybar with Bluetooth, backlight, recording indicator, system metrics, and help module
- Matrix-gold GRUB theme with binary rain aesthetic and gold-glow selected entries
- Hyprlock lockscreen with screenshot blur, gold input field, and Bible verse display
- Hypridle with progressive power saving (dim → lock → display off → suspend)
- Plymouth boot animation with custom EIGHT.ONE theme
- Papirus-Dark icon theme, JetBrainsMono Nerd Font everywhere

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
- **Ollama** — local AI inference (disabled at boot, starts on-demand via holy-ai)

### Performance & Battery
- **VFR + VRR** — variable frame rate and adaptive sync for battery savings
- **TLP** — AMD Ryzen-optimized power management with AMDGPU settings
- **zram** — 50% RAM compressed swap (zstd), effective ~12GB on 8GB system
- **earlyoom** — kills memory hogs before system freezes (prefers browser tabs)
- **Kernel tuning** — swappiness=10, BBR TCP, inotify limits for IDEs
- **Blur/shadows disabled** — Hyprland runs lean on integrated GPU
- **Ollama disabled at boot** — starts on-demand to save ~300MB idle RAM

### Custom Utilities

EIGHT.ONE ships 26 custom scripts accessible from the terminal, Waybar, or the command palette (`Ctrl+Super+Space`):

| Utility | Description |
|---------|-------------|
| `holy-settings` | Central TUI settings menu |
| `holy-menu` | Command palette with 45+ actions |
| `holy-ai` | Local AI assistant via Ollama |
| `holy-bible` | Keyboard-driven Bible search |
| `holy-keys` | Keyboard shortcut reference |
| `holy-wifi` | WiFi manager with signal bars (nmcli) |
| `holy-bluetooth` | Bluetooth scan/pair/connect (bluetoothctl) |
| `holy-display` | Monitor resolution/scale/toggle (wlr-randr) |
| `holy-ssh` | SSH key generator with clipboard copy |
| `holy-record` | Screen recording toggle (wf-recorder) |
| `holy-clip` | Clipboard history manager (cliphist) |
| `holy-flow` | Pomodoro-style focus timer with Waybar integration |
| `holy-focus` | Distraction blocker (modifies /etc/hosts) |
| `holy-vibes` | Background audio (lo-fi, ambient, chants) |
| `holy-sabbath` | Sunday rest reminder (Waybar module) |
| `holy-intent` | Daily intention setter |
| `holy-dash` | Project dashboard |
| `holy-dev` | Project scaffolding (Rust, Node, Python, Go) |
| `holy-git` | Git workflow helper |
| `holy-install` | Guided Arch installer (archinstall) |
| `holy-welcome` | 7-step premium onboarding wizard |
| `holy-ide` | AI-integrated VS Code with first-run setup |
| `holy-aur` | Self-bootstrapping AUR helper (paru) |
| `holy-browser` | Brave Browser via Flatpak auto-installer |
| `holy-notify` | Notification history viewer |
| `eightone-update` | 3-channel system updater (pacman, scripts, AUR) |

### Keyboard Shortcuts

Every binding is unique — no conflicts.

| Shortcut | Action |
|----------|--------|
| `Super + Enter` | Terminal (Kitty) |
| `Super + Space` | App Launcher (Fuzzel) |
| `Ctrl+Super + Space` | Command Palette (holy-menu) |
| `Super + Q` | Close Window |
| `Super + Escape` | Lock Screen |
| `Super + A` | AI Assistant (holy-ai) |
| `Super + B` | Browser (Brave) |
| `Super + Shift+B` | Bible Search (holy-bible) |
| `Super + C` | IDE (VS Code) |
| `Super + D` | Project Dashboard (holy-dash) |
| `Super + Shift+D` | New Project (holy-dev) |
| `Super + E` | File Manager (Yazi) |
| `Super + N` | Notifications (holy-notify) |
| `Super + O` | Obsidian Notes |
| `Super + T` | Zellij Multiplexer |
| `Super + W` | Flow Timer (holy-flow) |
| `Super + Shift+W` | Builder Mode (holy-focus) |
| `Super + Shift+A` | AI Chat (holy-ai TUI) |
| `Super + V` | Clipboard History |
| `Super + S` | Screenshot (area) |
| `Super + Shift+S` | Screenshot (full) |
| `Super + Shift+R` | Toggle Screen Recording |
| `Super + ,` | Settings (holy-settings) |
| `Super + /` | Shortcut Reference (holy-keys) |
| `Super + F` | Fullscreen |
| `Super + Shift+F` | Toggle Floating |
| `Super + P` | Pseudo-tile |
| `Super + ;` | Toggle Split |
| `Super + Shift+E` | Exit Hyprland |
| `Super + H/J/K/L` | Focus (vim-style) |
| `Super + Shift+H/J/K/L` | Move Window |
| `Super + Ctrl+H/J/K/L` | Resize Window |
| `Super + 1-9` | Switch Workspace |
| `Super + Shift+1-9` | Move Window to Workspace |
| `Super + `` ` | Toggle Scratchpad |

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
  packages.x86_64               All packages (organized by category)
  profiledef.sh                  Build profile and file permissions
  airootfs/
    etc/
      greetd/config.toml         Auto-login → /usr/local/bin/start-hyprland
      default/grub               GRUB config with EIGHT.ONE theme
      default/earlyoom           OOM killer configuration
      tlp.conf                   TLP power management (AMD Ryzen optimized)
      sysctl.d/99-eightone.conf  Kernel tuning (memory, network, I/O)
      systemd/zram-generator.conf  Compressed swap (zstd, 50% RAM)
      pacman.conf                Pacman with color and parallel downloads
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
        wallpaper.png            Desktop wallpaper (dark + gold)
    usr/
      local/bin/
        start-hyprland           Session launcher (env vars, VM detection)
        holy-*                   26 custom TUI utilities
      share/
        grub/themes/eightone/    Matrix-gold GRUB theme
        plymouth/themes/eightone/ Boot animation
```

## License

MIT

---

<p align="center">
  <b>Built by <a href="https://github.com/Artaeon">Artaeon</a></b>
</p>
