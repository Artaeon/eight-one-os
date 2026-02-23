#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="eight-one-os"
iso_label="EIGHT_ONE_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="Artaeon & Raphael Lugmayr"
iso_application="EIGHT.ONE OS Distribution"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux'
           'uefi.systemd-boot')
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/root/.gnupg"]="0:0:700"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/local/bin/Installation_guide"]="0:0:755"
  ["/usr/local/bin/livecd-sound"]="0:0:755"
  ["/usr/local/bin/holy-bible"]="0:0:755"
  ["/usr/local/bin/holy-ai"]="0:0:755"
  ["/usr/local/bin/holy-focus"]="0:0:755"
  ["/usr/local/bin/holy-vibes"]="0:0:755"
  ["/usr/local/bin/holy-sabbath"]="0:0:755"
  ["/usr/local/bin/start-hyprland"]="0:0:755"
  ["/usr/local/bin/holy-welcome"]="0:0:755"
  ["/usr/local/bin/holy-settings"]="0:0:755"
  ["/usr/local/bin/eightone-update"]="0:0:755"
  ["/usr/local/bin/holy-git"]="0:0:755"
  ["/usr/local/bin/holy-install"]="0:0:755"
  ["/usr/local/bin/holy-flow"]="0:0:755"
  ["/usr/local/bin/holy-intent"]="0:0:755"
  ["/usr/local/bin/holy-dash"]="0:0:755"
  ["/usr/local/bin/holy-dev"]="0:0:755"
  ["/usr/local/bin/holy-record"]="0:0:755"
  ["/usr/local/bin/holy-clip"]="0:0:755"
  ["/usr/local/bin/holy-ssh"]="0:0:755"
  ["/usr/local/bin/holy-wifi"]="0:0:755"
  ["/usr/local/bin/holy-bluetooth"]="0:0:755"
  ["/usr/local/bin/holy-display"]="0:0:755"
  ["/usr/local/bin/holy-aur"]="0:0:755"
)
