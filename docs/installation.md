# 🌟 Установка Dotfiles для BSPWM

Эта инструкция поможет установить и настроить dotfiles из репозитория [PDTPLR/Linux](https://github.com/PDTPLR/Linux) на Arch Linux (основная поддержка) или Ubuntu/Debian (частичная поддержка). Вы можете использовать автоматический скрипт install.sh или интерактивный install.py.

---

## 📋 Требования

- **ОС**: Arch Linux (рекомендуется) или Ubuntu/Debian.
- **Зависимости**: Пакеты из packages.txt (`bspwm`, `sxhkd`, `polybar`, `picom`, `rofi`, `dunst`, `fish`, `python`, `python-distro`, `python-inquirer`, `ttf-jetbrains-mono-nerd` и др.).
- **Рекомендуется**: Установите `yay` для AUR-пакетов на Arch Linux.
- **Разрешение экрана**: Оптимизировано для 1920x1080, но работает на других разрешениях с настройками (см. troubleshooting.md).

---

## 🚀 Быстрая установка (install.sh)

1. **Клонируйте репозиторий**:
    
    ```bash
    git clone https://github.com/PDTPLR/Linux.git
    cd Linux
    ```
    
2. **Запустите скрипт**:
    
    ```bash
    chmod +x scripts/install.sh
    ./scripts/install.sh
    ```
    
    > Устанавливает пакеты, копирует конфигурации (configs/), скрипты (scripts/utils/, scripts/color-scripts/, scripts/fetchs/), обои (assets/wallpapers/), шрифты (assets/fonts/), настраивает `~/.xinitrc` и `PATH`.
    
3. **Запустите BSPWM**:
    
    ```bash
    startx
    ```
    

---

## 🛠 Интерактивная установка (install.py)

1. **Клонируйте репозиторий** (см. выше).
    
2. **Запустите скрипт с меню**:
    
    ```bash
    chmod +x scripts/install.py
    ./scripts/install.py
    ```
    
    > Позволяет выбрать компоненты: пакеты, конфигурации, скрипты, обои, шрифты, настройка `.xinitrc` и `PATH`.
    
3. **Запустите BSPWM**:
    
    ```bash
    startx
    ```
    

---

## 🔧 Установка на других дистрибутивах

Для неподдерживаемых дистрибутивов выполните установку вручную:

1. **Установите пакеты** из packages.txt с помощью вашего пакетного менеджера (например, `dnf`, `zypper`).
2. **Скопируйте файлы**:
    
    ```bash
    cp -r configs/* ~/.config/
    cp .xinitrc .bashrc ~/
    cp -r scripts/utils/* scripts/color-scripts/* scripts/fetchs/* ~/.local/bin/
    chmod -R +x ~/.local/bin
    mkdir -p ~/Images
    cp -r assets/wallpapers/* ~/Images/
    mkdir -p ~/.local/share/fonts
    cp -r assets/fonts/* ~/.local/share/fonts/
    fc-cache -fv
    chmod +x ~/.config/bspwm/bspwmrc
    ```
    
3. **Настройте `.xinitrc`**:  
    Убедитесь, что последняя строка в `~/.xinitrc` — `exec bspwm`.

---

## ⚠ Примечания

- **Резервное копирование**: Скрипты создают резервные копии существующих файлов в `~/.config/backup-<дата-время>`.
- **Проблемы**: Если что-то не работает, смотрите troubleshooting.md.
- **Обратная связь**: Сообщайте об ошибках в [Issues](https://github.com/PDTPLR/Linux/issues).
