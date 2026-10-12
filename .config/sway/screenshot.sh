#!/bin/bash
# Скриншоты: файл в ~/Pictures/Screenshots + копия в буфер обмена
# Использование: screenshot.sh area|output|window

DIR="$HOME/Pictures/Screenshots"
NAME="$(date +%Y-%m-%d_%H-%M-%S)"
mkdir -p "$DIR"

case "$1" in
    area)
        GEOM="$(slurp -d)" || exit 0
        FILE="$DIR/$NAME.png"
        grim -g "$GEOM" "$FILE" || exit 1
        MSG="Область сохранена"
        ;;
    output)
        OUTPUT="$(swaymsg -t get_outputs | python3 -c '
import sys, json
print(next(o["name"] for o in json.load(sys.stdin) if o["focused"]))
')" || exit 1
        FILE="$DIR/${NAME}_monitor.png"
        grim -o "$OUTPUT" "$FILE" || exit 1
        MSG="Монитор сохранён"
        ;;
    window)
        GEOM="$(swaymsg -t get_tree | python3 -c '
import sys, json
def find(n):
    if n.get("focused"):
        return n
    for c in n.get("nodes", []) + n.get("floating_nodes", []):
        f = find(c)
        if f:
            return f
r = find(json.load(sys.stdin))["rect"]
print("%d,%d %dx%d" % (r["x"], r["y"], r["width"], r["height"]))
')" || exit 1
        FILE="$DIR/${NAME}_window.png"
        grim -g "$GEOM" "$FILE" || exit 1
        MSG="Окно сохранено"
        ;;
    *)
        echo "Использование: $0 area|output|window" >&2
        exit 1
        ;;
esac

wl-copy < "$FILE"
notify-send -i camera "Screenshot" "$MSG"
