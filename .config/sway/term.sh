#!/bin/sh
# Терминал: fastfetch + zsh (если zsh не установлен — sh)
command -v fastfetch >/dev/null && fastfetch

if command -v zsh >/dev/null; then
    exec zsh
else
    exec sh
fi
