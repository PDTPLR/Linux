#!/bin/bash

# Скрипт установки dotfiles для BSPWM
# Репозиторий: https://github.com/PDTPLR/Linux
# Автор: PDTPLR

# Путь к папке dotfiles
DOTFILES_DIR="$HOME/git/dotfiles"

# Список необходимых пакетов
DEPENDENCIES="bspwm sxhkd polybar picom rofi dunst feh xorg xorg-xinit ttf-dejavu noto-fonts ttf-font-awesome"

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

# Установка зависимостей
install_dependencies() {
    echo -e "${YELLOW}Обнаружен дистрибутив: $DISTRO${NC}"
    case "$DISTRO" in
        arch)
            if ! command_exists pacman; then
                echo -e "${RED}Ошибка: pacman не найден. Убедитесь, что вы используете Arch Linux.${NC}"
                exit 1
            fi
            echo -e "${GREEN}Установка зависимостей для Arch Linux...${NC}"
            sudo pacman -S --needed $DEPENDENCIES
            ;;
        ubuntu|debian)
            if ! command_exists apt; then
                echo -e "${RED}Ошибка: apt не найден. Убедитесь, что вы используете Ubuntu/Debian.${NC}"
                exit 1
            fi
            echo -e "${GREEN}Обновление списка пакетов...${NC}"
            sudo apt update
            echo -e "${GREEN}Установка зависимостей для Ubuntu/Debian...${NC}"
            sudo apt install -y bspwm sxhkd polybar picom rofi dunst feh xorg x11-xserver-utils fonts-dejavu fonts-noto fonts-font-awesome
            ;;
        *)
            echo -e "${RED}Дистрибутив $DISTRO не поддерживается! Установите зависимости вручную:${NC}"
            echo "$DEPENDENCIES"
            exit 1
            ;;
    esac
}

# Копирование конфигурационных файлов
copy_dotfiles() {
    echo -e "${GREEN}Копирование конфигурационных файлов...${NC}"
    mkdir -p ~/.config
    cp -r $DOTFILES_DIR/bspwm ~/.config/ || { echo -e "${RED}Ошибка копирования bspwm${NC}"; exit 1; }
    cp -r $DOTFILES_DIR/sxhkd ~/.config/ || { echo -e "${RED}Ошибка копирования sxhkd${NC}"; exit 1; }
    cp -r $DOTFILES_DIR/polybar ~/.config/ || { echo -e "${RED}Ошибка копирования polybar${NC}"; exit 1; }
    cp -r $DOTFILES_DIR/picom ~/.config/ || { echo -e "${RED}Ошибка копирования picom${NC}"; exit 1; }
    cp -r $DOTFILES_DIR/rofi ~/.config/ || { echo -e "${RED}Ошибка копирования rofi${NC}"; exit 1; }
    mkdir -p ~/.config/dunst
    cp $DOTFILES_DIR/dunstrc ~/.config/dunst/ || { echo -e "${RED}Ошибка копирования dunstrc${NC}"; exit 1; }
    cp $DOTFILES_DIR/.xinitrc ~ || { echo -e "${RED}Ошибка копирования .xinitrc${NC}"; exit 1; }
    cp $DOTFILES_DIR/.bashrc ~ || { echo -e "${RED}Ошибка копирования .bashrc${NC}"; exit 1; }

    # Установка прав
    chmod +x ~/.config/bspwm/bspwmrc
    echo -e "${GREEN}Конфигурационные файлы успешно скопированы!${NC}"
}

# Проверка и создание .xinitrc
setup_xinitrc() {
    if grep -q "exec bspwm" ~/.xinitrc; then
        echo -e "${YELLOW}.xinitrc уже настроен для BSPWM.${NC}"
    else
        echo "exec bspwm" >> ~/.xinitrc
        echo -e "${GREEN}Добавлена команда 'exec bspwm' в ~/.xinitrc${NC}"
    fi
}

# Основная функция
main() {
    check_root
    detect_distro
    install_dependencies
    copy_dotfiles
    setup_xinitrc

    echo -e "${GREEN}Установка завершена!${NC}"
    echo -e "Для запуска BSPWM выполните:"
    echo -e "  ${YELLOW}startx${NC}"
    echo -e "Подробности в README.md и Docs/installation.md."
}

# Запуск
main
