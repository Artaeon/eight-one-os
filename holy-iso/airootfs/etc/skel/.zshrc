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
echo "  [Super + B]       Holy Bible        [Super + T]  Zellij Terminal"
echo "  [Super + E]       File Manager      [Super + V]  Clipboard History"
echo "  [Super + S]       Screenshot        [Super+Shift+R] Screen Record"
echo "  [Super + Q]       Close Window      [Super + ,]  Settings"
echo ""

# Aliases for modern CLI tools
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first'
alias cat='bat --style=plain'
alias top='btop'
alias find='fd'
alias lg='lazygit'
alias ldk='lazydocker'
alias g='git'
alias gs='git s'
alias gc='git commit'
alias gp='git push'
alias gl='git lg'
<<<<<<< HEAD
# Welcome wizard is now triggered via Hyprland exec-once autostart
=======
# First-run welcome wizard (greetd handles Hyprland launch — no TTY code needed)
if [[ ! -f "$HOME/.welcome_done" ]]; then
    holy-welcome
fi
>>>>>>> e659395 (fix(hyprland): resolve startup issues with greetd and env var deduplication)

# Show Fastfetch system info once setup is complete
if [[ -f "$HOME/.welcome_done" ]]; then
    fastfetch
fi

# Zsh Plugins (Arch Linux packages)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# Zoxide (smart cd)
eval "$(zoxide init zsh)" 2>/dev/null

# Builder's daily intention (only in Hyprland session)
if [ -n "$WAYLAND_DISPLAY" ]; then
    holy-intent check 2>/dev/null
fi
