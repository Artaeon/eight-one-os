# EIGHT.ONE OS — Auto-start Hyprland on tty1
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec /usr/local/bin/start-hyprland
fi
