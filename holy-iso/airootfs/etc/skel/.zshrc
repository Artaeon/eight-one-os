autoload -Uz compinit promptinit
compinit
promptinit

# Holy User Environment
export PATH=$HOME/.local/bin:$PATH

# Starship prompt
eval "$(starship init zsh)"

# Theme / Colors
YELLOW="\e[33m"
RESET="\e[0m"
BOLD="\e[1m"
CYAN="\e[36m"

# Welcome message (Custom 8.1 Infinity Logo)
echo -e "${YELLOW}${BOLD}"
echo "       _   _"
echo "     ( _ ) / |"
echo "     / _ \ | |"
echo "    | (_) || |"
echo "     \___/ |_|"
echo -e "      EIGHT.ONE OS (INFINITY ONE)${RESET}"
echo -e "\n${CYAN}✝ Welcome to the Holy Developer Environment ✝${RESET}\n"
echo "  [Super + Enter]   Terminal          [Super + D]  Project Dashboard"
echo "  [Super + Space]   App Launcher      [Super + N]  New Project"
echo "  [Super + A]       Holy AI           [Super + W]  Flow Timer"
echo "  [Super + B]       Holy Bible        [Super+Shift+B] Builder Mode"
echo "  [Super + Q]       Close Window      [Super + ,]  Settings"
echo ""

# Aliases for modern CLI tools
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first'
alias cat='bat --style=plain'
alias top='btop'
alias find='fd'
# Ensure user is ready
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    if [ ! -f "$HOME/.welcome_done" ]; then
        holy-welcome
    fi
fi

# Show Fastfetch system info once setup is complete
if [ -f "$HOME/.welcome_done" ]; then
    fastfetch
fi

# Start Hyprland on TTY1 if not already running
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    echo -e "\n${YELLOW}Press ENTER to launch Hyprland desktop, or type 'skip' to stay in terminal:${RESET}"
    read -r choice
    if [ "$choice" != "skip" ]; then
        start-hyprland
    fi
fi

# Zsh Plugins (Arch Linux packages)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# Builder's daily intention (only in Hyprland session)
if [ -n "$WAYLAND_DISPLAY" ]; then
    holy-intent check 2>/dev/null
fi
