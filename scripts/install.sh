#!/bin/bash

# Скрипт установки dotfiles для BSPWM, пакетов, скриптов и обоев
# Репозиторий: https://github.com/PDTPLR/Linux
# Автор: PDTPLR

# Путь к папке dotfiles
DOTFILES_DIR="$HOME/git/dotfiles"

# Файл с списком пакетов
PACKAGES_FILE="$DOTFILES_DIR/packages.txt"

# Цветной вывод
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Функция для проверки команд
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Проверка root-прав
check_root() {
    if [ "$EUID" -eq 0 ]; then
        echo -e "${RED}Ошибка: Скрипт не должен запускаться от root. Используйте обычного пользователя с sudo.${NC}"
        exit 1
    fi
}

# Определение дистрибутива
detect_distro() {
    if [ -f /etc/os-release ]; then
        DISTRO=$(grep -oP '(?<=^ID=).+' /etc/os-release | tr -d '"')
    else
        echo -e "${RED}Ошибка: Не удалось определить дистрибутив. Файл /etc/os-release отсутствует.${NC}"
        exit 1
    fi
}

# Установка пакетов из packages.txt
install_packages() {
    if [ ! -f "$PACKAGES_FILE" ]; then
        echo -e "${RED}Ошибка: Файл $PACKAGES_FILE не найден. Сгенерируйте его с помощью 'pacman -Qe | awk \"{print \$1}\" > packages.txt'.${NC}"
        exit 1
    fi

    PACKAGES=$(cat "$PACKAGES_FILE" | tr '\n' ' ')

    echo -e "${YELLOW}Обнаружен дистрибутив: $DISTRO${NC}"
    case "$DISTRO" in
        arch)
            if ! command_exists pacman; then
                echo -e "${RED}Ошибка: pacman не найден. Убедитесь, что вы используете Arch Linux.${NC}"
                exit 1
            fi
            echo -e "${GREEN}Установка пакетов из $PACKAGES_FILE для Arch Linux...${NC}"
            sudo pacman -S --needed $PACKAGES
            ;;
        ubuntu|debian)
            if ! command_exists apt; then
                echo -e "${RED}Ошибка: apt не найден. Убедитесь, что вы используете Ubuntu/Debian.${NC}"
                exit 1
            fi
            echo -e "${YELLOW}Предупреждение: Некоторые пакеты из $PACKAGES_FILE могут отсутствовать или иметь другие имена в Ubuntu/Debian. Проверяйте вручную.${NC}"
            echo -e "${GREEN}Обновление списка пакетов...${NC}"
            sudo apt update
            echo -e "${GREEN}Установка доступных пакетов...${NC}"
            sudo apt install -y $(cat "$PACKAGES_FILE" | grep -vE "yay|linux-|*-nerd|base|base-devel|grub|intel-ucode|linux-firmware") || true
            ;;
        *)
            echo -e "${RED}Дистрибутив $DISTRO не поддерживается! Установите пакеты вручную из $PACKAGES_FILE:${NC}"
            cat "$PACKAGES_FILE"
            exit 1
            ;;
    esac
}

# Резервное копирование и копирование конфигурационных файлов
copy_dotfiles() {
    # Резервное копирование
    BACKUP_DIR=~/.config/backup-$(date +%F-%H%M%S)
    echo -e "${YELLOW}Создание резервной копии в $BACKUP_DIR...${NC}"
    mkdir -p $BACKUP_DIR
    mv ~/.config/bspwm $BACKUP_DIR 2>/dev/null
    mv ~/.config/sxhkd $BACKUP_DIR 2>/dev/null
    mv ~/.config/polybar $BACKUP_DIR 2>/dev/null
    mv ~/.config/picom $BACKUP_DIR 2>/dev/null
    mv ~/.config/rofi $BACKUP_DIR 2>/dev/null
    mv ~/.config/dunst $BACKUP_DIR 2>/dev/null
    mv ~/.config/fish $BACKUP_DIR 2>/dev/null
    mv ~/.local/bin $BACKUP_DIR 2>/dev/null
    mv ~/.xinitrc $BACKUP_DIR 2>/dev/null
    mv ~/.bashrc $BACKUP_DIR 2>/dev/null
    mv ~/Pictures/wallpapers $BACKUP_DIR 2>/dev/null

    # Копирование
    echo -e "${GREEN}Копирование конфигурационных файлов...${NC}"
    mkdir -p ~/.config
    cp -r $DOTFILES_DIR/bspwm ~/.config/ || { echo -e "${RED}Ошибка копирования bspwm${NC}"; exit 1; }
    cp -r $DOTFILES_DIR/sxhkd ~/.config/ || { echo -e "${RED}Ошибка копирования sxhkd${NC}"; exit 1; }
    cp -r $DOTFILES_DIR/polybar ~/.config/ || { echo -e "${RED}Ошибка копирования polybar${NC}"; exit 1; }
    cp -r $DOTFILES_DIR/picom ~/.config/ || { echo -e "${RED}Ошибка копирования picom${NC}"; exit 1; }
    cp -r $DOTFILES_DIR/rofi ~/.config/ || { echo -e "${RED}Ошибка копирования rofi${NC}"; exit 1; }
    mkdir -p ~/.config/dunst
    cp $DOTFILES_DIR/dunstrc ~/.config/dunst/ || { echo -e "${RED}Ошибка копирования dunstrc${NC}"; exit 1; }
    cp -r $DOTFILES_DIR/fish ~/.config/ || { echo -e "${RED}Ошибка копирования fish${NC}"; exit 1; }
    cp $DOTFILES_DIR/.xinitrc ~ || { echo -e "${RED}Ошибка копирования .xinitrc${NC}"; exit 1; }
    cp $DOTFILES_DIR/.bashrc ~ || { echo -e "${RED}Ошибка копирования .bashrc${NC}"; exit 1; }

    # Копирование пользовательских скриптов
    mkdir -p ~/.local/bin
    cp -r $DOTFILES_DIR/bin/* ~/.local/bin/ || { echo -e "${RED}Ошибка копирования bin скриптов${NC}"; exit 1; }
    chmod -R +x ~/.local/bin

    # Копирование обоев
    mkdir -p ~/Pictures/wallpapers
    cp -r $DOTFILES_DIR/wallpapers/* ~/Pictures/wallpapers/ || { echo -e "${RED}Ошибка копирования обоев${NC}"; exit 1; }

    echo -e "${GREEN}Конфигурационные файлы, скрипты и обои успешно скопированы!${NC}"
}

# Проверка и настройка .xinitrc
setup_xinitrc() {
    if grep -q "exec bspwm" ~/.xinitrc; then
        echo -e "${YELLOW}.xinitrc уже настроен для BSPWM.${NC}"
    else
        echo "exec bspwm" >> ~/.xinitrc
        echo -e "${GREEN}Добавлена команда 'exec bspwm' в ~/.xinitrc${NC}"
    fi
}

# Добавление ~/.local/bin в PATH
setup_path() {
    if ! grep -q ".local/bin" ~/.bashrc && ! grep -q ".local/bin" ~/.config/fish/config.fish; then
        echo -e "${YELLOW}Добавление ~/.local/bin в PATH...${NC}"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        echo 'set -gx PATH $HOME/.local/bin $PATH' >> ~/.config/fish/config.fish
        echo -e "${GREEN}PATH обновлён для Bash и Fish.${NC}"
    else
        echo -e "${YELLOW}~/.local/bin уже в PATH.${NC}"
    fi
}

# Основная функция
main() {
    check_root
    detect_distro
    install_packages
    copy_dotfiles
    setup_xinitrc
    setup_path

    echo -e "${GREEN}Установка завершена!${NC}"
    echo -e "Для запуска BSPWM выполните:"
    echo -e "  ${YELLOW}startx${NC}"
    echo -e "Подробности в README.md и Docs/installation.md."
}

# Запуск
main
