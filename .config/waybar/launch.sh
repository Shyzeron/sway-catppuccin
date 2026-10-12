#!/bin/bash
# Запуск waybar с перезапуском при падении.
# При старте sway waybar иногда падает (SIGSEGV в GTK) — без этого бар
# не появлялся до перезагрузки конфига.

# Останавливаем предыдущий экземпляр этого скрипта и waybar
for pid in $(pgrep -f "^/bin/bash .*/waybar/launch\.sh$"); do
    [ "$pid" != "$$" ] && kill "$pid" 2>/dev/null
done
pkill -x waybar
while pgrep -x waybar >/dev/null; do sleep 0.1; done

LOG="${XDG_RUNTIME_DIR:-/tmp}/waybar.log"

for attempt in 1 2 3 4 5; do
    waybar >"$LOG" 2>&1
    status=$?
    # 0 — штатный выход, 143 — убит через SIGTERM (перезапуск конфига): не перезапускаем
    [ "$status" -eq 0 ] || [ "$status" -eq 143 ] && exit 0
    echo "waybar упал (код $status), перезапуск #$attempt" >>"$LOG.crashes"
    sleep 1
done
