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
echo "  [Super + Enter]   Terminal (Alacritty)"
echo "  [Super + Space]   App Launcher (Fuzzel)"
echo "  [Super + A]       Holy AI Assistant"
echo "  [Super + B]       Holy Bible Search"
echo "  [Super + Q]       Close Window"
echo "  [CLI] holy-focus  Blocks distractions"
echo "  [CLI] holy-vibes  Plays worship/lofi audio"
echo ""

# Start Hyprland automatically on TTY1 if not already running
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    exec start-hyprland
fi
