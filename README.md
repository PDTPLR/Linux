# 🌌 Dotfiles для BSPWM от PDTPLR 🌌

![GitHub stars](https://img.shields.io/github/stars/PDTPLR/Linux?style=social)  
![GitHub license](https://img.shields.io/github/license/PDTPLR/Linux)

Лёгкая и стильная настройка BSPWM для Arch Linux с поддержкой Ubuntu/Debian. Идеально для тех, кто ценит минимализм, производительность и красоту рабочего стола! 🌈

## 📖 О проекте

Настраиваемое окружение для работы и творчества, доступное для всех.

- **ОС**: [Arch Linux](https://archlinux.org) (основная), Ubuntu/Debian (частичная поддержка)
- **Оконный менеджер**: BSPWM
- **Панель**: Polybar
- **Композитор**: Picom
- **Терминал**: Alacritty
- **Лаунчер**: Rofi
- **Уведомления**: Dunst
- **Оболочка**: Fish

## 🖼 Галерея

| ![Рабочий стол](screenshots/bspwm.png) | ![Polybar](screenshots/btop.png) | ![Rofi](screenshots/ranger.png) |


## ✨ Возможности

- **Гибкость**: Легко настраивайте BSPWM, Polybar, Rofi и другие компоненты (configs/).
- **Обои**: 63 изображения для динамического фона (assets/wallpapers/).
- **Шрифты**: Nerd Fonts для иконок и терминалов.
- **Скрипты**: Утилиты для системы, Wi-Fi, обоев и цветов (scripts/utils/, scripts/color-scripts/, scripts/fetchs/).
- **Горячие клавиши**: Оптимизированы для удобства (configs/sxhkd/sxhkdrc).
- **Лёгкость**: Менее 700 МБ памяти.
- **Автоматизация**: Установка через install.sh или install.py.
- **Документация**: Инструкции для всех (docs/installation.md, docs/troubleshooting.md, docs/usage.md, docs/scripts.md, docs/hotkeys.md, docs/contributing.md).

## 🌍 Для всех

Проект создан для пользователей любого уровня:

- Поддержка разных разрешений экрана.
- Инструкции для Arch Linux и Ubuntu/Debian (docs/installation.md).
- Документация на русском для новичков и профи.
- Обратная связь через [Issues](https://github.com/PDTPLR/Linux/issues).

## ⚠ Важно

Оптимизировано для Arch Linux и 1920x1080, но работает на других системах и разрешениях с настройками. Проблемы? Смотрите docs/troubleshooting.md или пишите в [Issues](https://github.com/PDTPLR/Linux/issues).

## 📦 Установка

### 🚀 Быстрая установка (install.sh)

1. Клонируйте репозиторий:
    
    ```bash
    git clone https://github.com/PDTPLR/Linux.git
    cd Linux
    ```
    
2. Запустите скрипт:
    
    ```bash
    chmod +x scripts/install.sh
    ./scripts/install.sh
    ```
    
    > Устанавливает пакеты (packages.txt), копирует конфигурации, скрипты, обои, шрифты, настраивает .xinitrc и `PATH`.
    
3. Запустите BSPWM:
    
    ```bash
    startx
    ```
    

### 🛠 Интерактивная установка (install.py)

1. Клонируйте репозиторий (см. выше).
2. Запустите скрипт:
    
    ```bash
    chmod +x scripts/install.py
    ./scripts/install.py
    ```
    
    > Выберите компоненты: пакеты, конфигурации, скрипты, обои, шрифты, `.xinitrc`, `PATH`.
    
3. Запустите BSPWM:
    
    ```bash
    startx
    ```
    

Подробности: docs/installation.md.

## 🛠 После установки

Проблемы? Проверьте docs/troubleshooting.md. Частые случаи:

- **Батарея в Polybar**: Настройте scripts/utils/battery-alert и configs/polybar/config.ini.
- **Анимации тормозят**: Отключите `picom` в configs/bspwm/bspwmrc.
- **Обои**: Проверьте `feh` и scripts/utils/random_wallpaper.
- **Шрифты**: Обновите кэш: `fc-cache -fv`.

## 🎹 Горячие клавиши

- **Терминал**: `Super + Enter`
- **Обои**: `Super + W`
- **Раскладка**: `Shift + Alt`
- **Rofi**: `Super + D`
- **Блокировка**: `Super + Shift + L`
- **Выбор цвета**: `Super + Shift + X`
- **Polybar**: `Super + Shift + P`
- **Плавающее окно**: `Super + Space`
- **Закрыть окно**: `Super + C`
- **Рабочие столы**: `Super + 1-9`
- **Переместить окно**: `Super + Shift + 1-9`
- **Перезапуск BSPWM**: `Ctrl + Shift + R`
- **Скриншот**: `Print`

Полный список: docs/hotkeys.md, configs/sxhkd/sxhkdrc. Используйте scripts/utils/show-keybindings.sh.

## 🤝 Как помочь

1. Форкните: [PDTPLR/Linux](https://github.com/PDTPLR/Linux).
2. Создайте ветку: `git checkout -b feature/идея`.
3. Закоммитьте: `git commit -m "Добавлена идея"`.
4. Запушьте: `git push origin feature/идея`.
5. Создайте PR: [Pull Requests](https://github.com/PDTPLR/Linux/pulls).

Идеи и баги: [Issues](https://github.com/PDTPLR/Linux/issues). Подробности: docs/contributing.md.


