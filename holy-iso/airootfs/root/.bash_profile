# Ensure bash logs into zsh immediately if it's the root user on TTY1
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    exec zsh
fi
