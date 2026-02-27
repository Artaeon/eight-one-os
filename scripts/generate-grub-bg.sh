#!/usr/bin/env bash
# Generate Matrix-style GRUB background for EIGHT.ONE OS
set -euo pipefail

OUT="holy-iso/airootfs/usr/share/grub/themes/eightone/background.png"
WIDTH=1920
HEIGHT=1080
BG="#0a0a0f"
FONT="Adwaita-Mono"

echo "Generating ${WIDTH}x${HEIGHT} Matrix background..."

# Build draw commands for falling character columns
draw_cmds=""

# Ambient columns — dim gold characters scattered vertically
for i in $(seq 1 100); do
    x=$(( RANDOM % WIDTH ))
    y_start=$(( RANDOM % HEIGHT ))
    alpha_pct=$(( RANDOM % 20 + 5 ))  # 5-25%
    alpha_frac=$(printf '0.%02d' "$alpha_pct")
    fill="rgba(212,175,55,${alpha_frac})"
    chars="01{}[]<>/|:;.+-=*#@010110100101"
    num_rows=$(( RANDOM % 20 + 5 ))
    for row in $(seq 0 "$num_rows"); do
        y=$(( y_start + row * 16 ))
        if (( y > HEIGHT )); then break; fi
        idx=$(( RANDOM % ${#chars} ))
        ch="${chars:$idx:1}"
        draw_cmds="$draw_cmds -fill '$fill' -annotate +${x}+${y} '$ch'"
    done
done

# Brighter "leading" characters at head of columns
for i in $(seq 1 40); do
    x=$(( RANDOM % WIDTH ))
    y=$(( RANDOM % HEIGHT ))
    ch=$(( RANDOM % 2 ))
    draw_cmds="$draw_cmds -fill 'rgba(212,175,55,0.70)' -annotate +${x}+${y} '$ch'"
done

# Generate the image in one pass
eval magick -size "${WIDTH}x${HEIGHT}" "xc:${BG}" \
    -font "$FONT" -pointsize 13 \
    $draw_cmds \
    -font "$FONT" -pointsize 80 \
    -fill "'rgba(212,175,55,0.10)'" \
    -gravity center -annotate +0+0 "'EIGHT.ONE'" \
    "'$OUT'"

echo "Done: $OUT"
ls -lh "$OUT"
