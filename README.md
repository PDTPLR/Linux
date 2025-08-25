# BSPWM Dotfiles

![Основной десктоп](screenshots/desktop.png)

Добро пожаловать в мои персональные dotfiles для настройки минималистичного и продуктивного рабочего окружения на базе оконного менеджера **BSPWM** на Arch Linux. Этот репозиторий включает конфигурации для BSPWM, SXHKD, Polybar, Picom, Rofi, Dunst, а также скрипт для автоматической установки.

## Особенности

- **Минималистичный интерфейс**: Лёгкий и быстрый BSPWM с настраиваемой панелью Polybar.
- **Горячие клавиши**: Удобные комбинации через SXHKD (например, `Super + Enter` для терминала).
- **Настраиваемые уведомления**: Dunst для стильных и ненавязчивых уведомлений.
- **Анимации и эффекты**: Прозрачность и анимации окон через Picom.
- **Лаунчер приложений**: Rofi для быстрого запуска программ и меню.
- **Автоматизация**: Скрипт `install.sh` для упрощения установки на Arch Linux и других дистрибутивах.

## Требования

- **Операционная система**: Arch Linux (или другой Linux-дистрибутив с адаптацией).
- **Разрешение экрана**: Оптимизировано для 1920x1080 (настройте под своё разрешение).
- **Зависимости**:
    - `bspwm` — оконный менеджер.
    - `sxhkd` — управление горячими клавишами.
    - `polybar` — панель задач.
    - `picom` — композитор для анимаций.
    - `rofi` — лаунчер приложений.
    - `dunst` — уведомления.
    - `feh` — установка обоев.
    - `xorg`, `xorg-xinit` — X-сервер.
- **Рекомендуемые шрифты**: `ttf-dejavu`, `noto-fonts`, `ttf-font-awesome` для Polybar и Rofi.

## Установка

### Шаг 1: Клонирование репозитория

Склонируйте репозиторий в вашу домашнюю директорию:

```bash
git clone https://github.com/PDTPLR/Linux.git
cd Linux
```

### Шаг 2: Установка зависимостей

Для Arch Linux выполните:

```bash
sudo pacman -S bspwm sxhkd polybar picom rofi dunst feh xorg xorg-xinit ttf-dejavu noto-fonts ttf-font-awesome
```

Для Ubuntu:

```bash
sudo apt install bspwm sxhkd polybar picom rofi dunst feh xorg x11-xserver-utils fonts-dejavu fonts-noto fonts-font-awesome
```

Для других дистрибутивов адаптируйте команды пакетного менеджера (см. `Docs/installation.md`).

### Шаг 3: Запуск скрипта установки

Скрипт `install.sh` автоматически скопирует конфигурации в `~/.config` и настроит окружение:

```bash
chmod +x scripts/install.sh
./scripts/install.sh
```

### Шаг 4: Настройка X-сервера

Добавьте BSPWM в `~/.xinitrc` для запуска:

```bash
echo "exec bspwm" > ~/.xinitrc
```

### Шаг 5: Запуск BSPWM

Запустите X-сервер:

```bash
startx
```

## Конфигурация

- **BSPWM**: `~/.config/bspwm/bspwmrc` — настройка отступов, границ окон и правил для приложений.
- **SXHKD**: `~/.config/sxhkd/sxhkdrc` — горячие клавиши (например, `Super + Enter` для терминала, `Super + D` для Rofi).
- **Polybar**: `~/.config/polybar/config.ini` — настройка панели (модули для CPU, RAM, батареи, яркости).
- **Picom**: `~/.config/picom/picom.conf` — настройка анимаций и прозрачности.
- **Rofi**: `~/.config/rofi/config.rasi` — настройка меню приложений.
- **Dunst**: `~/.config/dunst/dunstrc` — настройка уведомлений.
- **Обои**: Устанавливаются через `feh` в `bspwmrc` (например, `feh --bg-fill /path/to/wallpaper.jpg`).
- **Темы**: Переключайте темы Polybar с помощью `scripts/change_theme.sh`:
    
    ```bash
    ./scripts/change_theme.sh light
    ./scripts/change_theme.sh dark
    ```
    

Подробности в `Docs/installation.md`.

## Скриншоты

- Основной десктоп: ![Desktop](screenshots/desktop.png)
- Меню Rofi: ![Rofi](screenshots/rofi.png)

## Устранение неполадок

- **Polybar не показывает батарею**:
    
    - Проверьте имя батареи:
        
        ```bash
        ls /sys/class/power_supply/
        ```
        
    - Обновите `scripts/battery-alert`, заменив `BAT0` на ваше имя батареи (например, `BAT1`).
    - Перезапустите Polybar:
        
        ```bash
        polybar-msg cmd restart
        ```
        
- **Анимации тормозят**:
    
    - Закомментируйте `picom &` в `~/.config/bspwm/bspwmrc`:
        
        ```bash
        # picom &
        ```
        
    - Или настройте `picom.conf` для меньшей нагрузки.
- **Проблемы с драйверами**:
    
    - Убедитесь, что установлены драйверы видеокарты:
        
        ```bash
        sudo pacman -S xf86-video-intel  # для Intel
        sudo pacman -S nvidia nvidia-utils  # для NVIDIA
        sudo pacman -S mesa  # для AMD
        ```
        
- **Ошибки разрешения экрана**:
    
    - Проверьте разрешение:
        
        ```bash
        xrandr
        ```
        
    - Настройте `polybar` или `bspwmrc` под ваше разрешение.

Подробности в `Docs/troubleshooting.md`.

## Вклад

1. Форкните репозиторий.
2. Внесите изменения в своей ветке.
3. Создайте Pull Request с описанием изменений.
4. Вопросы и предложения? Пишите в Issues.

## Благодарности

- Вдохновение: [Zproger/bspwm-dotfiles](https://github.com/Zproger/bspwm-dotfiles)
- Сообщества: r/unixporn, r/bspwm
- Arch Wiki за документацию

## Лицензия

MIT License — см. LICENSE.
