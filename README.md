# BSPWM Dotfiles

![GitHub stars](https://img.shields.io/github/stars/PDTPLR/Linux?style=social)  
![GitHub license](https://img.shields.io/github/license/PDTPLR/Linux)

![Основной десктоп](screenshots/desktop.jpg)

Мои персональные dotfiles для минималистичного окружения на базе **BSPWM** в Arch Linux. Репозиторий включает конфигурации, скрипты, обои, шрифты и документацию для настройки рабочего окружения.

## Особенности

- **BSPWM**: Лёгкий тайловый оконный менеджер с настраиваемыми правилами (configs/bspwm/).
- **SXHKD**: Горячие клавиши для управления окнами и приложениями (configs/sxhkd/).
- **Polybar**: Настраиваемая панель с модулями CPU, RAM, батареи и сети (configs/polybar/).
- **Picom**: Композитор для прозрачности и анимаций (configs/picom/).
- **Rofi**: Лаунчер приложений с поддержкой тем (configs/rofi/).
- **Dunst**: Лёгкие уведомления (configs/dunst/).
- **Fish Shell**: Интерактивная оболочка с автодополнением (configs/fish/).
- **Скрипты**: Утилиты для управления системой, обоями и сетью (scripts/utils/, scripts/color-scripts/, scripts/fetchs/).
- **Обои**: Коллекция из 63 изображений (assets/wallpapers/).
- **Шрифты**: Nerd Fonts для иконок и терминалов (assets/fonts/).
- **Автоматизация**: Скрипты установки `install.sh` (scripts/install.sh) и `install.py` (scripts/install.py) с интерактивным меню.
- **Документация**: Подробные инструкции (docs/installation.md, docs/troubleshooting.md, scripts/docs/).

## Скриншоты

![Десктоп](screenshots/desktop.jpg)  
![Rofi](screenshots/rofi.jpg)  
![Polybar](screenshots/polybar.jpg)

> **Примечание**: Добавьте свои скриншоты в папку screenshots/ и обновите пути выше.

## Требования

- **ОС**: Arch Linux (основная поддержка), Ubuntu/Debian (частичная).
- **Зависимости**: См. packages.txt (включает `bspwm`, `sxhkd`, `polybar`, `picom`, `rofi`, `dunst`, `fish`, `python`, `python-distro`, `python-inquirer`, `ttf-jetbrains-mono-nerd` и др.).
- **Рекомендуется**: Установите `yay` для AUR-пакетов на Arch Linux.

## Установка

### Быстрая установка (install.sh)

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
    
    > Устанавливает пакеты, копирует конфигурации, скрипты, обои, шрифты, настраивает `.xinitrc` и `PATH`.
    
3. Запустите BSPWM:
    
    ```bash
    startx
    ```
    

### Интерактивная установка (install.py)

1. Клонируйте репозиторий (см. выше).
2. Запустите скрипт с меню:
    
    ```bash
    chmod +x scripts/install.py
    ./scripts/install.py
    ```
    
    > Позволяет выбрать компоненты: пакеты, конфигурации, скрипты, обои, шрифты, настройка `.xinitrc` и `PATH`.
    
3. Запустите BSPWM:
    
    ```bash
    startx
    ```
    

Подробные инструкции: docs/installation.md.

## Устранение неполадок

Если что-то не работает (например, Polybar не показывает батарею, обои не меняются, шрифты отображаются некорректно), см. docs/troubleshooting.md.

## Скрипты

- **Утилиты**: scripts/utils/ — скрипты для управления батареей (`battery-alert`), Bluetooth (`bluetooth_menu.sh`), яркостью (`brightness`), Wi-Fi (`wifimenu`), обоями (`random_wallpaper`) и др.
- **Цветовые скрипты**: scripts/color-scripts/ — визуализация цветов для терминалов.
- **Fetch-скрипты**: scripts/fetchs/ — вывод системной информации.
- **Документация**: scripts/docs/ — описания всех скриптов (например, scripts/docs/Battery-alert.md).

## Использование

- **Запуск BSPWM**:
    
    ```bash
    startx
    ```
    
- **Смена обоев**:
    
    ```bash
    ~/.local/bin/random_wallpaper
    ```
    
- **Горячие клавиши**: См. configs/sxhkd/sxhkdrc или выполните:
    
    ```bash
    ~/.local/bin/show-keybindings.sh
    ```
    

## Лицензия

MIT License

## Контрибьюция

1. Форкните репозиторий.
2. Создайте ветку: `git checkout -b feature/ваша-фича`.
3. Внесите изменения и закоммитьте: `git commit -m "Добавлена фича"`.
4. Запушьте: `git push origin feature/ваша-фича`.
5. Создайте Pull Request на GitHub.

Сообщайте об ошибках в [Issues](https://github.com/PDTPLR/Linux/issues).

## Благодарности

Вдохновлено проектами [Zproger/bspwm-dotfiles](https://github.com/Zproger/bspwm-dotfiles) и [gh0stzk/dotfiles](https://github.com/gh0stzk/dotfiles).
