#!/bin/bash
# Определяет дистрибутив и возвращает иконку для waybar
# Если дистрибутив не распознан — не выводит ничего (модуль скрывается)

source /etc/os-release 2>/dev/null || exit 0

case "$ID" in
    arch)         printf '{"text": "\uf303", "tooltip": "Arch Linux"}\n' ;;
    ubuntu)       printf '{"text": "\uf31b", "tooltip": "Ubuntu"}\n' ;;
    debian)       printf '{"text": "\uf306", "tooltip": "Debian"}\n' ;;
    fedora)       printf '{"text": "\uf30a", "tooltip": "Fedora"}\n' ;;
    opensuse-leap|opensuse-tumbleweed|opensuse)
                  printf '{"text": "\uf314", "tooltip": "openSUSE"}\n' ;;
    manjaro)      printf '{"text": "\uf312", "tooltip": "Manjaro"}\n' ;;
    endeavouros)  printf '{"text": "\uf322", "tooltip": "EndeavourOS"}\n' ;;
    linuxmint)    printf '{"text": "\uf30e", "tooltip": "Linux Mint"}\n' ;;
    pop)          printf '{"text": "\uf32a", "tooltip": "Pop!_OS"}\n' ;;
    centos)       printf '{"text": "\uf304", "tooltip": "CentOS"}\n' ;;
    gentoo)       printf '{"text": "\uf30d", "tooltip": "Gentoo"}\n' ;;
    nixos)        printf '{"text": "\uf313", "tooltip": "NixOS"}\n' ;;
    # Не распознан — пингвин как заглушка
    *)            printf '{"text": "🐧", "tooltip": "%s"}
' "${PRETTY_NAME:-Linux}" ;;
esac
