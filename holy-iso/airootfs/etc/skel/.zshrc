autoload -Uz compinit promptinit
compinit
promptinit

# Holy User Environment
export PATH=$HOME/.local/bin:$PATH
export EDITOR=nvim
export VISUAL=nvim

# Zsh History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY APPEND_HISTORY

# Starship prompt
eval "$(starship init zsh)"

# Theme / Colors
YELLOW="\e[33m"
RESET="\e[0m"
BOLD="\e[1m"
CYAN="\e[36m"

# Welcome message (only in top-level interactive shell, not nested/subshells)
if [[ -z "$EIGHTONE_BANNER_SHOWN" && -o interactive ]]; then
    export EIGHTONE_BANNER_SHOWN=1
    echo -e "${YELLOW}${BOLD}"
    echo "       _   _"
    echo "     ( _ ) / |"
    echo "     / _ \ | |"
    echo "    | (_) || |"
    echo "     \___/ |_|"
    echo -e "      EIGHT.ONE OS (INFINITY ONE)${RESET}"
    echo -e "\n${CYAN}✝ Welcome to the Holy Developer Environment ✝${RESET}\n"
    echo "  [Super + Enter]   Terminal          [Super + D]     Dashboard"
    echo "  [Super + Space]   App Launcher      [Super + Shift+D] New Project"
    echo "  [Super + A]       Holy AI           [Super + W]     Flow Timer"
    echo "  [Super + B]       Browser           [Super + T]     Zellij"
    echo "  [Super + E]       File Manager      [Super + V]     Clipboard"
    echo "  [Super + S]       Screenshot        [Super + Shift+R] Record"
    echo "  [Super + Escape]  Lock Screen       [Super + /]     All Shortcuts"
    echo ""
fi

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
# Welcome wizard is now triggered via Hyprland exec-once autostart

# Show Fastfetch system info once setup is complete
if [[ -f "$HOME/.welcome_done" ]]; then
    fastfetch
fi

# Zsh Plugins (Arch Linux packages)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# Zoxide (smart cd)
eval "$(zoxide init zsh)" 2>/dev/null

# Mise (dev environment manager — Ruby, Node, PHP, Python, etc.)
eval "$(mise activate zsh)" 2>/dev/null

# Builder's daily intention (only in Hyprland session)
if [ -n "$WAYLAND_DISPLAY" ]; then
    holy-intent check 2>/dev/null
fi
