#!/usr/bin/env bash
# Раскладывает конфиги в ~/.config.
# Существующие конфиги сохраняются в ~/.config/<имя>.bak-<дата>.

set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.config"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d-%H%M%S)"

mkdir -p "$DEST"

for dir in "$SRC"/*/; do
    name="$(basename "$dir")"
    if [ -e "$DEST/$name" ]; then
        mv "$DEST/$name" "$DEST/$name.bak-$STAMP"
        echo "Бэкап: $DEST/$name -> $DEST/$name.bak-$STAMP"
    fi
    cp -r "$dir" "$DEST/$name"
    echo "Установлено: $DEST/$name"
done

chmod +x "$DEST"/sway/*.sh "$DEST"/waybar/scripts/*.sh
mkdir -p "$HOME/Pictures/Screenshots"

echo "Готово. Перезагрузи sway: \$mod+Shift+C"
