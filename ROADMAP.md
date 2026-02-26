# EIGHT.ONE OS — Roadmap

## Current State (v2026.02)

EIGHT.ONE OS is a keyboard-driven Arch Linux distribution built with `archiso`. It ships a complete Hyprland desktop, 27 custom `holy-*` TUI utilities, AI integration (Ollama, Claude Code, Gemini CLI), and a unified dark-gold theme — all pre-configured out of the box.

**Target hardware:** Matebook (Ryzen 3500U, 8GB RAM)
**Test suite:** 232 validations across 15 categories — all passing

---

## Competitive Analysis: EIGHT.ONE vs Omarchy

### Architecture

| | EIGHT.ONE OS | Omarchy (3.3.3) |
|---|---|---|
| **Type** | Custom Arch ISO (archiso) | Post-install layer on vanilla Arch |
| **Delivery** | Bootable ISO — live session, rescue disk, installer | `curl` script on existing Arch |
| **Config management** | Static files baked into ISO | Git-managed repo with versioned migrations |
| **Updates** | `eightone-update` (curl scripts from GitHub) | `omarchy-update` (git pull + pacman + migrations + snapshots) |
| **Versioning** | Date-based releases | Semver (3.3.3), channels (stable/edge/dev) |
| **Package repo** | Official Arch repos only | Custom signed Pacman repo (`pkgs.omarchy.org`) |
| **Filesystem** | Any | btrfs only (required for snapshots) |
| **Bootloader** | GRUB (Matrix-gold theme) | Limine (with snapshot boot entries) |

### Scale

| | EIGHT.ONE | Omarchy |
|---|---|---|
| **Custom scripts** | 27 `holy-*` tools | 161 `omarchy-*` commands |
| **Themes** | 1 (gold/black) | 14 stock + template-based custom themes |
| **Base packages** | 223 | ~130 base + modular installers |

### Desktop Stack

| Component | EIGHT.ONE | Omarchy |
|-----------|-----------|---------|
| Compositor | Hyprland | Hyprland |
| Bar | Waybar (glassmorphism) | Waybar |
| Launcher | Fuzzel | Walker (launcher + clipboard + emoji + calc) |
| Notifications | Mako | Mako |
| Lock | Hyprlock (Bible verses) | Hyprlock |
| Idle | Hypridle | Hypridle |
| Night light | — | Hyprsunset |
| OSD | — | SwayOSD |
| Terminal | Kitty | Alacritty + Kitty + Ghostty |
| File manager | Yazi (TUI) | Nautilus (GUI) |
| Browser | Brave (Flatpak) | Chromium (native) |
| Screenshots | grim + slurp | Hyprshot + Satty (annotation) |
| Recording | wf-recorder | gpu-screen-recorder (GPU-accel + webcam) |
| Clipboard | cliphist + Fuzzel | Walker clipboard module |
| Audio control | wpctl keybinds | SwayOSD + wiremix |
| Bluetooth | holy-bluetooth (custom TUI) | bluetui (dedicated app) |
| WiFi | holy-wifi (custom TUI) | impala (dedicated app) |
| Login | greetd (auto-login) | SDDM |

### Developer Environment

| | EIGHT.ONE | Omarchy |
|---|---|---|
| Editor | Neovim (LazyVim) + VS Code | Neovim (LazyVim + omarchy-nvim) |
| Language versions | System packages | mise (15+ languages) |
| Docker | In ISO | Optional installer with log limits + DNS |
| Git | git + delta + 15 aliases | git + delta + aliases |
| Web apps | — | Chromium PWAs as .desktop entries |
| Project scaffolding | holy-dev (Rust, Node, Python, Go) | — |

### AI Integration

| | EIGHT.ONE | Omarchy |
|---|---|---|
| Local AI | Ollama + holy-ai TUI | — |
| Claude Code | Included | Claude Code skill (OS-aware) |
| Gemini CLI | Included | — |
| AI voice | — | voxtype (dictation) |

### Update & Safety

| | EIGHT.ONE | Omarchy |
|---|---|---|
| Updates | `eightone-update` (pacman + curl scripts) | Full pipeline: snapshot → keyring → pacman → yay → migrations → hooks → log analysis |
| Rollback | — | btrfs snapshots, bootable from Limine |
| Migrations | — | Versioned shell scripts, run once per upgrade |
| Config refresh | Manual | `omarchy-refresh-*` resets any config (with backup) |

### Security

| | EIGHT.ONE | Omarchy |
|---|---|---|
| Firewall | UFW | UFW + ufw-docker |
| Fingerprint | — | Setup wizard |
| FIDO2 | — | Setup wizard |
| DNS encryption | — | DNS-over-TLS (Cloudflare) |
| Drive encryption | — | Managed setup |

### Where EIGHT.ONE Wins

These are unique features Omarchy does not have:

- **Bootable live ISO** — try before install, works as rescue/recovery disk
- **Local AI** — Ollama with model management, holy-ai chat TUI
- **Bible integration** — holy-bible search, lock screen verses, Sabbath reminder
- **Focus tools** — Pomodoro timer (holy-flow) with Waybar + streaks, distraction blocker (holy-focus), daily intentions (holy-intent)
- **Background music** — holy-vibes streams (lo-fi, chants, ambient)
- **Onboarding wizard** — 7-step holy-welcome with password, browser, AI setup
- **Project scaffolding** — holy-dev creates Rust/Node/Python/Go projects
- **Custom GRUB theme** — Matrix-gold binary rain
- **Plymouth boot animation** — custom 36-frame boot splash
- **Recovery toolkit** — clonezilla, testdisk, ddrescue, fsarchiver, partclone
- **Comprehensive test suite** — 232 automated validations

---

## Roadmap: Surpassing Omarchy

### Phase 1: Foundation Hardening (Priority: HIGH)

#### 1.1 — Layered Configuration Architecture
**Goal:** Users should never need to edit source files. Changes survive updates.

- [ ] Split `hyprland.conf` into modular files: `autostart.conf`, `bindings.conf`, `looknfeel.conf`, `input.conf`, `windows.conf`
- [ ] Each module: ship default in `/usr/share/eightone/defaults/hypr/`, source user override from `~/.config/hypr/` if it exists
- [ ] Pattern: `source = ~/.config/hypr/bindings.conf` (user file) falls back to default if missing
- [ ] Apply same pattern to: Waybar, Kitty, Mako, Fuzzel, Zellij, Starship
- [ ] Add `holy-refresh <component>` to reset any config to defaults (with backup)

#### 1.2 — Update Pipeline with Rollback
**Goal:** Updates should never break the system.

- [ ] Integrate Snapper into `eightone-update`: auto-snapshot before every update
- [ ] Add GRUB boot entries for snapshots via `grub-btrfs` (already in packages)
- [ ] Add `eightone-rollback` command to restore from a snapshot
- [ ] Add migration system: numbered scripts in `/usr/share/eightone/migrations/` that run once per version
- [ ] Track update state in `/var/lib/eightone/update-state`
- [ ] Add `--dry-run` flag to `eightone-update`

#### 1.3 — Versioning & Release Channels
**Goal:** Users know exactly what version they're running.

- [ ] Add `/usr/share/eightone/version` file (semver, e.g., `1.0.0`)
- [ ] Add `holy-version` command showing: version, build date, commit, kernel, packages
- [ ] Add channel support: `stable` (default) and `edge` (latest main branch)
- [ ] CI: tag releases with semver, generate changelogs from conventional commits

### Phase 2: Theme Engine (Priority: HIGH)

#### 2.1 — Template-Based Theme System
**Goal:** Switch the entire desktop's look with one command.

- [ ] Define theme format: `colors.toml` with keys: `accent`, `background`, `foreground`, `surface`, `error`, `warning`, `success`, `color0-color15`
- [ ] Create `.tpl` template files for: Hyprland, Hyprlock, Waybar CSS, Kitty, Mako, Fuzzel, Alacritty, Zellij, Starship, GTK, QT
- [ ] Build `holy-theme set <name>` — reads `colors.toml`, substitutes `{{ key }}` tokens, generates configs, restarts processes
- [ ] Build `holy-theme list` / `holy-theme current` / `holy-theme next`
- [ ] Ship 5+ stock themes: `gold` (current default), `midnight`, `everforest`, `catppuccin`, `nord`
- [ ] Per-theme wallpaper support with `holy-theme bg-next` cycling
- [ ] Per-theme Neovim colorscheme and VS Code theme

#### 2.2 — Font Management
**Goal:** Change fonts system-wide with one command.

- [ ] `holy-font set <name>` — updates Kitty, Waybar CSS, Hyprlock, Fuzzel, GTK, QT
- [ ] `holy-font list` — shows available Nerd Fonts
- [ ] Ship with JetBrainsMono (default), FiraCode, CascadiaCode, Iosevka

### Phase 3: Desktop Polish (Priority: MEDIUM)

#### 3.1 — OSD & Visual Feedback
- [ ] Add `swayosd` to packages and autostart — volume/brightness visual overlay
- [ ] Replace raw `wpctl`/`brightnessctl` keybindings with SwayOSD equivalents

#### 3.2 — Night Light
- [ ] Add `hyprsunset` to packages
- [ ] Add `holy-nightlight` toggle command
- [ ] Add `Super+Shift+N` keybinding
- [ ] Add Waybar module showing night light status

#### 3.3 — Screenshot Enhancement
- [ ] Add `satty` (screenshot annotation editor) to packages
- [ ] Update screenshot keybind: `grim -g "$(slurp)" - | satty -f -` for area screenshots
- [ ] Add screenshot-to-file option (not just clipboard)

#### 3.4 — Screen Recording Enhancement
- [ ] Evaluate `gpu-screen-recorder` as replacement for `wf-recorder` (GPU-accelerated, lower CPU)
- [ ] Add webcam overlay option to holy-record
- [ ] Add audio capture toggle

#### 3.5 — Multi-Terminal Support
- [ ] Add Alacritty and Ghostty configs (already themed)
- [ ] Add `holy-terminal set <kitty|alacritty|ghostty>` to switch default
- [ ] Update `$terminal` variable in hyprland.conf dynamically

### Phase 4: Developer Experience (Priority: MEDIUM)

#### 4.1 — Language Version Manager
- [ ] Integrate `mise` (formerly `rtx`) for multi-language version management
- [ ] Add `holy-dev env` to install language runtimes: Ruby, Node, Go, Python, Rust, PHP, Elixir
- [ ] Configure mise shell hooks in `.zshrc`

#### 4.2 — Web App Support
- [ ] Add `holy-webapp install <url> <name>` — creates Chromium/Brave PWA `.desktop` entry
- [ ] Add `holy-webapp remove <name>`
- [ ] Ship pre-configured web apps: GitHub, ChatGPT, YouTube

#### 4.3 — Claude Code Skill
- [ ] Create `/usr/share/eightone/claude-skill/SKILL.md` describing the entire EIGHT.ONE system
- [ ] Symlink to `~/.claude/skills/eightone/`
- [ ] Include: file locations, config syntax, keybindings, theme format, available commands
- [ ] Claude Code becomes OS-aware and can modify configs correctly

#### 4.4 — Git Identity in Welcome Wizard
- [ ] Add a git identity step to `holy-welcome` between password and browser setup
- [ ] Prompt for name and email via gum
- [ ] Write to `~/.gitconfig` via `git config --global`

### Phase 5: System Management (Priority: MEDIUM)

#### 5.1 — Debug & Diagnostics
- [ ] Add `holy-debug` — generates comprehensive system report: kernel, GPU, packages, services, errors, disk, memory, network
- [ ] Output to file for easy sharing in bug reports

#### 5.2 — Drive & Encryption Management
- [ ] Add `holy-drive` — list drives, check health (smartctl), set LUKS passwords
- [ ] Add `holy-encrypt` — guided full-disk encryption setup

#### 5.3 — Fingerprint & FIDO2
- [ ] Add `holy-fingerprint` — guided fingerprint enrollment (fprintd)
- [ ] Add `holy-fido2` — guided FIDO2 hardware key setup
- [ ] Integrate with PAM for sudo and login

#### 5.4 — DNS Encryption
- [ ] Add `holy-dns` — switch between DHCP, Cloudflare DoT, Quad9 DoT
- [ ] Configure systemd-resolved with DNS-over-TLS

### Phase 6: Advanced Features (Priority: LOW)

#### 6.1 — Windows VM
- [ ] Add `holy-windows` — install/launch/stop Windows 11 VM via Docker + RDP
- [ ] Use dockur/windows Docker image
- [ ] Add .desktop entry for Windows VM

#### 6.2 — Hibernation Support
- [ ] Add `holy-hibernate` — setup btrfs swapfile for hibernation
- [ ] Configure resume kernel parameters
- [ ] Add hibernate option to holy-power

#### 6.3 — Voice Dictation
- [ ] Evaluate voxtype or whisper.cpp for local AI dictation
- [ ] Add `holy-dictate` command
- [ ] Add Waybar indicator when dictating

#### 6.4 — Customization Hooks
- [ ] Add hook system: `~/.config/eightone/hooks/post-update`, `theme-set`, `font-set`
- [ ] Run user scripts automatically on system events
- [ ] Document hook API

#### 6.5 — Menu Extensions
- [ ] Allow users to add custom entries to holy-menu via `~/.config/eightone/menu-extensions.sh`
- [ ] Support per-project menu entries (`.eightone/menu.sh` in project root)

---

## Metrics to Track

| Metric | Current | Target |
|--------|---------|--------|
| Custom scripts | 27 | 50+ |
| Stock themes | 1 | 5+ |
| Test validations | 232 | 400+ |
| Supported terminals | 1 | 3 |
| Language runtimes | System only | 15+ (via mise) |
| Update rollback | None | btrfs snapshots |
| Security features | UFW only | UFW + fingerprint + FIDO2 + DoT |

---

## Guiding Principles

1. **Keyboard-first** — every feature accessible without a mouse
2. **Works offline** — local AI, no cloud dependencies for core features
3. **Opinionated defaults** — one right way, zero post-install configuration
4. **Developer-focused** — every tool a developer needs, nothing they don't
5. **Faith-integrated** — Bible, Sabbath, intentions, focus — unique identity
6. **8GB-conscious** — every feature must respect the RAM constraint
7. **Test everything** — automated validation prevents regressions
8. **One command** — every feature invocable with a single `holy-*` command

---

*Built by [Artaeon](https://github.com/Artaeon)*
