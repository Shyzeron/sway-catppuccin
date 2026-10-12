#!/bin/bash
FLAG="/tmp/sway-gaps-enabled"

if [ -f "$FLAG" ]; then
    swaymsg gaps inner all set 0
    swaymsg gaps outer all set 0
    rm "$FLAG"
    notify-send -i preferences-desktop "Gaps" "Отступы выключены"
else
    swaymsg gaps inner all set 12
    swaymsg gaps outer all set 12
    touch "$FLAG"
    notify-send -i preferences-desktop "Gaps" "Отступы включены"
fi
