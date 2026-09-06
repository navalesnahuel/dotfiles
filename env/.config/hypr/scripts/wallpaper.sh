#!/usr/bin/env bash
set -euo pipefail

WALL_DIR="$HOME/.local/share/wallpapers"
CONF="$HOME/.config/hypr/hyprpaper.conf"
THEME="$HOME/.config/rofi/wallpaper.rasi"

# Pick a wallpaper with rofi (grid + thumbnails).
choice="$(
    for f in "$WALL_DIR"/*; do
        [ -f "$f" ] || continue
        printf '%s\x00icon\x1f%s\n' "$(basename "$f")" "$f"
    done | rofi -dmenu -i -p "Wallpaper" -show-icons -theme "$THEME" \
        -kb-element-next "Control+n" -kb-element-prev "Control+p" \
        -kb-row-up "Up" -kb-row-down "Down"
)"

[ -z "${choice:-}" ] && exit 0
WALL="$WALL_DIR/$choice"
[ -f "$WALL" ] || {
    echo "Not found: $WALL"
    exit 1
}

# Make sure exactly one hyprpaper is running.
if ! pgrep -x hyprpaper >/dev/null; then
    hyprpaper >/dev/null 2>&1 &
    sleep 0.5
fi

# Build the config contents once.
MONITORS="$(hyprctl monitors | awk '/^Monitor/ {print $2}')"
gen_conf() {
    echo "splash = false"
    echo ""
    for m in $MONITORS; do
        echo "wallpaper {"
        echo "        monitor = $m"
        echo "        path = $WALL"
        echo "    }"
    done
}

# Persist FIRST, before touching the live daemon. hyprpaper reads this file to
# decide which wallpaper to load on startup, so writing it is what makes the
# choice survive a reboot. It must not be skipped just because the IPC call
# below fails (with `set -e` a failing hyprctl would abort the script before
# persistence ran -- the bug that made wallpapers reset on reboot).
gen_conf >"$CONF"

# Apply live. `|| true` so a transient IPC failure doesn't abort the script
# (persistence already happened above, so the next reboot is still correct).
for m in $MONITORS; do
    hyprctl hyprpaper wallpaper "$m,$WALL" >/dev/null 2>&1 || true
done

echo "Wallpaper set: $choice"
