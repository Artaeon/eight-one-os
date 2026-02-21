#!/usr/bin/env bash
set -e -u
sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
usermod -s /usr/bin/zsh root

# Create the holy live user
useradd -m -g users -G wheel,audio,video,input,storage -s /usr/bin/zsh holy
passwd -d holy
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel

cp -aT /etc/skel/ /root/
chmod 700 /root
systemctl enable systemd-networkd systemd-resolved
systemctl enable ollama
systemctl set-default multi-user.target
