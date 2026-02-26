#!/usr/bin/env bash
set -uo pipefail

# EIGHT.ONE OS — Test Suite
# Validates scripts, configs, keybindings, packages, and permissions
# Usage: bash tests/test-eightone.sh

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ISO="$REPO_ROOT/holy-iso"
BIN="$ISO/airootfs/usr/local/bin"
SKEL="$ISO/airootfs/etc/skel"

PASS=0
FAIL=0
WARN=0
ERRORS=()

pass() { PASS=$((PASS + 1)); echo "  ✓ $1"; }
fail() { FAIL=$((FAIL + 1)); ERRORS+=("$1"); echo "  ✗ $1"; }
warn() { WARN=$((WARN + 1)); echo "  ⚠ $1"; }

section() { echo -e "\n\e[33m\e[1m── $1 ──\e[0m"; }

# ═══════════════════════════════════════════════════
# 1. BASH SYNTAX VALIDATION
# ═══════════════════════════════════════════════════
section "Bash Syntax"

for script in "$BIN"/*; do
    [ -f "$script" ] || continue
    name=$(basename "$script")

    # Skip non-bash scripts
    if head -1 "$script" | grep -qE '^#!.*python|^#!.*perl'; then
        continue
    fi

    if bash -n "$script" 2>/dev/null; then
        pass "$name — syntax OK"
    else
        fail "$name — bash syntax error"
    fi
done

# ═══════════════════════════════════════════════════
# 2. SHEBANG LINES
# ═══════════════════════════════════════════════════
section "Shebangs"

for script in "$BIN"/*; do
    [ -f "$script" ] || continue
    name=$(basename "$script")
    first_line=$(head -1 "$script")

    if [[ "$first_line" =~ ^#! ]]; then
        pass "$name — has shebang: $first_line"
    else
        fail "$name — missing shebang (first line: $first_line)"
    fi
done

# ═══════════════════════════════════════════════════
# 3. EXECUTABLE PERMISSIONS (git index)
# ═══════════════════════════════════════════════════
section "File Permissions (git)"

for script in "$BIN"/*; do
    [ -f "$script" ] || continue
    name=$(basename "$script")
    rel_path="${script#$REPO_ROOT/}"

    # Check git file mode
    mode=$(git -C "$REPO_ROOT" ls-files -s "$rel_path" 2>/dev/null | awk '{print $1}')
    if [[ "$mode" == "100755" ]]; then
        pass "$name — executable in git (755)"
    elif [[ "$mode" == "100644" ]]; then
        fail "$name — not executable in git (644)"
    elif [[ -z "$mode" ]]; then
        warn "$name — not tracked by git"
    fi
done

# ═══════════════════════════════════════════════════
# 4. PROFILEDEF.SH COVERAGE
# ═══════════════════════════════════════════════════
section "profiledef.sh Coverage"

profiledef="$ISO/profiledef.sh"
if [ ! -f "$profiledef" ]; then
    fail "profiledef.sh not found"
else
    for script in "$BIN"/*; do
        [ -f "$script" ] || continue
        name=$(basename "$script")
        if grep -q "/usr/local/bin/$name" "$profiledef"; then
            pass "$name — listed in profiledef.sh"
        else
            fail "$name — MISSING from profiledef.sh"
        fi
    done
fi

# ═══════════════════════════════════════════════════
# 5. JSON VALIDITY (Waybar config)
# ═══════════════════════════════════════════════════
section "JSON Configs"

waybar_config="$SKEL/.config/waybar/config"
if [ -f "$waybar_config" ]; then
    if jq empty "$waybar_config" 2>/dev/null; then
        pass "waybar/config — valid JSON"
    else
        fail "waybar/config — invalid JSON"
    fi

    # Check all modules referenced exist in modules-left/center/right
    modules_defined=$(jq -r '
        (.["modules-left"] // [])[] ,
        (.["modules-center"] // [])[] ,
        (.["modules-right"] // [])[]
    ' "$waybar_config" 2>/dev/null)

    for mod in $modules_defined; do
        # Waybar uses / in module names (e.g., hyprland/workspaces)
        key=$(echo "$mod" | tr '/' '\\/')
        if jq -e ".\"$mod\"" "$waybar_config" &>/dev/null; then
            pass "waybar module '$mod' — has config block"
        else
            warn "waybar module '$mod' — no config block (uses defaults)"
        fi
    done
else
    fail "waybar/config — file not found"
fi

# ═══════════════════════════════════════════════════
# 6. WAYBAR MODULE SCRIPT PATHS
# ═══════════════════════════════════════════════════
section "Waybar Module Scripts"

if [ -f "$waybar_config" ]; then
    # Extract exec paths from waybar config
    while IFS= read -r exec_path; do
        # Extract the command (first word of exec)
        cmd=$(echo "$exec_path" | awk '{print $1}')
        script_name=$(basename "$cmd")

        # Check if it's a holy-* or eightone-* script
        if [[ "$cmd" == /usr/local/bin/* ]]; then
            if [ -f "$BIN/$script_name" ]; then
                pass "waybar exec '$script_name' — script exists"
            else
                fail "waybar exec '$script_name' — script NOT FOUND"
            fi
        fi
    done < <(jq -r '.. | .exec? // empty' "$waybar_config" 2>/dev/null)
fi

# ═══════════════════════════════════════════════════
# 7. HYPRLAND KEYBINDING CONFLICTS
# ═══════════════════════════════════════════════════
section "Keybinding Conflicts"

hypr_conf="$SKEL/.config/hypr/hyprland.conf"
if [ -f "$hypr_conf" ]; then
    # Extract all bind lines (bind, binde, bindm)
    bindings=$(grep -E '^\s*bind(e|m)?\s*=' "$hypr_conf" | sed 's/^\s*//')

    # Build key combos: extract modifier+key from each binding
    declare -A seen_binds
    conflicts=0

    while IFS= read -r line; do
        # Format: bind = MODS, KEY, action, args
        # Remove the bind type prefix
        combo=$(echo "$line" | sed 's/^bind[em]*\s*=\s*//' | awk -F',' '{gsub(/^ +| +$/, "", $1); gsub(/^ +| +$/, "", $2); print toupper($1) "+" toupper($2)}')

        if [[ -n "${seen_binds[$combo]:-}" ]]; then
            fail "DUPLICATE keybinding: $combo"
            fail "  First:  ${seen_binds[$combo]}"
            fail "  Second: $line"
            ((conflicts++))
        else
            seen_binds[$combo]="$line"
        fi
    done <<< "$bindings"

    if [ "$conflicts" -eq 0 ]; then
        pass "No duplicate keybindings found (${#seen_binds[@]} bindings checked)"
    fi

    unset seen_binds
else
    fail "hyprland.conf — file not found"
fi

# ═══════════════════════════════════════════════════
# 8. NO GIT CONFLICT MARKERS
# ═══════════════════════════════════════════════════
section "Conflict Markers"

conflict_files=$(grep -rl '<<<<<<< \|=======$\|>>>>>>> ' "$ISO" 2>/dev/null || true)
if [ -z "$conflict_files" ]; then
    pass "No git conflict markers found in any file"
else
    while IFS= read -r f; do
        fail "Conflict markers in: ${f#$REPO_ROOT/}"
    done <<< "$conflict_files"
fi

# ═══════════════════════════════════════════════════
# 9. NO DUPLICATE PACKAGES
# ═══════════════════════════════════════════════════
section "Package List"

pkg_file="$ISO/packages.x86_64"
if [ -f "$pkg_file" ]; then
    # Strip comments and empty lines, find duplicates
    dupes=$(grep -v '^\s*#' "$pkg_file" | grep -v '^\s*$' | sort | uniq -d)
    if [ -z "$dupes" ]; then
        pkg_count=$(grep -v '^\s*#' "$pkg_file" | grep -v '^\s*$' | wc -l)
        pass "No duplicate packages ($pkg_count packages total)"
    else
        while IFS= read -r dupe; do
            fail "Duplicate package: $dupe"
        done <<< "$dupes"
    fi
else
    fail "packages.x86_64 — file not found"
fi

# ═══════════════════════════════════════════════════
# 10. KEY TOOL DEPENDENCIES IN PACKAGES
# ═══════════════════════════════════════════════════
section "Tool Dependencies"

# Tools that scripts depend on — must be in packages.x86_64
required_tools=(
    "hyprland"
    "hyprlock"
    "hyprpaper"
    "hypridle"
    "waybar"
    "fuzzel"
    "mako"
    "kitty"
    "wl-clipboard"
    "cliphist"
    "grim"
    "slurp"
    "wf-recorder"
    "wlr-randr"
    "mpv"
    "yt-dlp"
    "gum"
    "figlet"
    "bat"
    "btop"
    "eza"
    "fd"
    "fzf"
    "ripgrep"
    "yazi"
    "neovim"
    "code"
    "git"
    "docker"
    "ollama"
    "zsh"
    "starship"
    "zellij"
    "tmux"
    "brightnessctl"
    "bluez"
    "bluez-utils"
    "pipewire"
    "wireplumber"
    "networkmanager"
    "tlp"
    "earlyoom"
    "ufw"
    "greetd"
    "plymouth"
    "obsidian"
    "flatpak"
)

if [ -f "$pkg_file" ]; then
    for tool in "${required_tools[@]}"; do
        if grep -q "^${tool}$" "$pkg_file"; then
            pass "$tool — in packages.x86_64"
        else
            fail "$tool — MISSING from packages.x86_64"
        fi
    done
fi

# ═══════════════════════════════════════════════════
# 11. CRITICAL CONFIG FILES EXIST
# ═══════════════════════════════════════════════════
section "Critical Config Files"

critical_files=(
    "airootfs/etc/greetd/config.toml"
    "airootfs/etc/skel/.config/hypr/hyprland.conf"
    "airootfs/etc/skel/.config/hypr/hyprlock.conf"
    "airootfs/etc/skel/.config/hypr/hyprpaper.conf"
    "airootfs/etc/skel/.config/hypr/hypridle.conf"
    "airootfs/etc/skel/.config/waybar/config"
    "airootfs/etc/skel/.config/waybar/style.css"
    "airootfs/etc/skel/.config/kitty/kitty.conf"
    "airootfs/etc/skel/.config/fuzzel/fuzzel.ini"
    "airootfs/etc/skel/.config/mako/config"
    "airootfs/etc/skel/.zshrc"
    "airootfs/etc/skel/.gitconfig"
    "airootfs/etc/tlp.conf"
    "airootfs/etc/pacman.conf"
    "airootfs/root/customize_airootfs.sh"
    "airootfs/usr/local/bin/start-hyprland"
    "airootfs/usr/local/share/holy-bible/verses.txt"
    "profiledef.sh"
    "packages.x86_64"
)

for f in "${critical_files[@]}"; do
    if [ -f "$ISO/$f" ]; then
        pass "$f — exists"
    else
        fail "$f — MISSING"
    fi
done

# ═══════════════════════════════════════════════════
# 12. GREETD CONFIG VALIDATES
# ═══════════════════════════════════════════════════
section "greetd Config"

greetd="$ISO/airootfs/etc/greetd/config.toml"
if [ -f "$greetd" ]; then
    if grep -q 'command.*=.*"/usr/local/bin/start-hyprland"' "$greetd"; then
        pass "greetd — uses full path to start-hyprland"
    else
        fail "greetd — does NOT use full path to start-hyprland"
    fi

    if grep -q 'user.*=.*"holy"' "$greetd"; then
        pass "greetd — starts as user 'holy'"
    else
        fail "greetd — does NOT start as user 'holy'"
    fi
fi

# ═══════════════════════════════════════════════════
# 13. CUSTOMIZE_AIROOTFS.SH CHECKS
# ═══════════════════════════════════════════════════
section "customize_airootfs.sh"

customize="$ISO/airootfs/root/customize_airootfs.sh"
if [ -f "$customize" ]; then
    if grep -q 'docker' "$customize"; then
        pass "holy user has docker group"
    else
        fail "holy user MISSING docker group"
    fi

    if grep -q 'systemctl enable greetd' "$customize"; then
        pass "greetd service enabled"
    else
        fail "greetd service NOT enabled"
    fi

    if grep -q 'systemctl enable NetworkManager' "$customize"; then
        pass "NetworkManager service enabled"
    else
        fail "NetworkManager NOT enabled"
    fi

    if grep -q 'systemctl enable bluetooth' "$customize"; then
        pass "bluetooth service enabled"
    else
        fail "bluetooth NOT enabled"
    fi

    if grep -q 'systemctl enable tlp' "$customize"; then
        pass "TLP service enabled"
    else
        fail "TLP NOT enabled"
    fi

    if grep -q 'systemctl enable earlyoom' "$customize"; then
        pass "earlyoom service enabled"
    else
        fail "earlyoom NOT enabled"
    fi

    if grep -qE 'systemctl disable ollama|# Ollama disabled' "$customize"; then
        pass "Ollama disabled at boot (on-demand)"
    else
        warn "Ollama boot state unclear"
    fi
fi

# ═══════════════════════════════════════════════════
# 14. HYPRLAND CONFIG SANITY
# ═══════════════════════════════════════════════════
section "Hyprland Config Sanity"

if [ -f "$hypr_conf" ]; then
    # VFR should be enabled for battery
    if grep -q 'vfr\s*=\s*true' "$hypr_conf"; then
        pass "VFR enabled (battery saving)"
    else
        fail "VFR not enabled"
    fi

    # VRR should be enabled
    if grep -q 'vrr\s*=\s*[12]' "$hypr_conf"; then
        pass "VRR enabled (adaptive sync)"
    else
        warn "VRR not enabled"
    fi

    # Blur should be disabled (8GB RAM constraint)
    if grep -A2 'blur' "$hypr_conf" | grep -q 'enabled\s*=\s*false'; then
        pass "Blur disabled (RAM saving)"
    else
        warn "Blur may be enabled (check 8GB RAM impact)"
    fi

    # Shadow should be disabled
    if grep -A2 'shadow' "$hypr_conf" | grep -q 'enabled\s*=\s*false'; then
        pass "Shadows disabled (GPU saving)"
    else
        warn "Shadows may be enabled"
    fi

    # Touchpad should be configured (laptop target)
    if grep -q 'touchpad' "$hypr_conf"; then
        pass "Touchpad configuration present"
    else
        fail "No touchpad config (target is laptop)"
    fi

    # Gestures should be enabled
    if grep -q 'workspace_swipe\s*=\s*true' "$hypr_conf"; then
        pass "Workspace swipe gestures enabled"
    else
        warn "Workspace swipe not enabled"
    fi
fi

# ═══════════════════════════════════════════════════
# 15. SCRIPT CONTENT SANITY CHECKS
# ═══════════════════════════════════════════════════
section "Script Sanity"

# Check holy-vibes doesn't have the broken if/background pattern
vibes="$BIN/holy-vibes"
if [ -f "$vibes" ]; then
    if grep -qE 'if.*&\s*(then|;)' "$vibes"; then
        fail "holy-vibes — broken if/background pattern detected"
    else
        pass "holy-vibes — no broken if/background pattern"
    fi
fi

# Check holy-dash has proper operator grouping
dash="$BIN/holy-dash"
if [ -f "$dash" ]; then
    if grep -q '\] || \[.*\] && ' "$dash" && ! grep -q '{ \[.*\] || \[.*\]; } &&' "$dash"; then
        fail "holy-dash — ungrouped || && operator precedence bug"
    else
        pass "holy-dash — operator precedence OK"
    fi
fi

# Check start-hyprland ends with exec Hyprland
start="$BIN/start-hyprland"
if [ -f "$start" ]; then
    if tail -5 "$start" | grep -q 'exec Hyprland'; then
        pass "start-hyprland — ends with 'exec Hyprland'"
    else
        fail "start-hyprland — does NOT end with 'exec Hyprland'"
    fi
fi

# ═══════════════════════════════════════════════════
# RESULTS SUMMARY
# ═══════════════════════════════════════════════════
echo ""
echo -e "\e[1m═══════════════════════════════════════════════════\e[0m"
echo -e "\e[1m  TEST RESULTS\e[0m"
echo -e "\e[1m═══════════════════════════════════════════════════\e[0m"
echo -e "  \e[32m✓ Passed:   $PASS\e[0m"
echo -e "  \e[31m✗ Failed:   $FAIL\e[0m"
echo -e "  \e[33m⚠ Warnings: $WARN\e[0m"
echo ""

if [ "$FAIL" -gt 0 ]; then
    echo -e "\e[31m\e[1m  FAILURES:\e[0m"
    for err in "${ERRORS[@]}"; do
        echo -e "  \e[31m  • $err\e[0m"
    done
    echo ""
    exit 1
else
    echo -e "\e[32m\e[1m  All tests passed! EIGHT.ONE OS is ready.\e[0m"
    echo ""
    exit 0
fi
