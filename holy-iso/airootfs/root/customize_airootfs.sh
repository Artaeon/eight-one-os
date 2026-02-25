#!/usr/bin/env bash
set -e -u
sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
usermod -s /usr/bin/zsh root

# Create the holy live user
useradd -m -g users -G wheel,audio,video,input,storage -s /usr/bin/zsh holy
passwd -d holy
# NOPASSWD for live session (blank password). holy-welcome prompts to set a password.
# After password is set, user should edit /etc/sudoers.d/wheel to require password.
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel

echo "KEYMAP=de-latin1" > /etc/vconsole.conf

cp -aT /etc/skel/ /root/
chmod 700 /root
systemctl enable systemd-networkd systemd-resolved
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable greetd
systemctl enable ufw
systemctl enable tlp
systemctl enable earlyoom
# Ollama disabled on boot — starts on-demand via holy-ai to save RAM/battery
systemctl disable ollama 2>/dev/null || true
systemctl set-default graphical.target

# Configure UFW firewall via config files (can't run ufw in chroot)
sed -i 's/^ENABLED=no/ENABLED=yes/' /etc/ufw/ufw.conf 2>/dev/null || true
sed -i 's/^DEFAULT_INPUT_POLICY=.*/DEFAULT_INPUT_POLICY="DROP"/' /etc/default/ufw 2>/dev/null || true
sed -i 's/^DEFAULT_OUTPUT_POLICY=.*/DEFAULT_OUTPUT_POLICY="ACCEPT"/' /etc/default/ufw 2>/dev/null || true
sed -i 's/^DEFAULT_FORWARD_POLICY=.*/DEFAULT_FORWARD_POLICY="DROP"/' /etc/default/ufw 2>/dev/null || true

# Set Plymouth theme
plymouth-set-default-theme eightone

# Enable CUPS printing
systemctl enable cups

# Configure Snapper for automatic BTRFS snapshots
if command -v snapper &>/dev/null; then
    snapper --no-dbus -c root create-config / 2>/dev/null || true
fi

# Configure Flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true

# Pre-loading of AI models removed to speed up ISO build.
# Users can run `ollama pull qwen2.5-coder:1.5b` after installation.
