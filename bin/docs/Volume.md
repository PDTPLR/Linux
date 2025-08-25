
## Исходный код
```bash
#!/bin/bash

## Script To Manage Speaker Volume For Axyl OS.

# Get Volume
get_volume() {
    volume=$(pamixer --get-volume)
    echo "$volume"
}

# Get icons
get_icon() {
    current=$(get_volume)
    if [[ "$current" -eq "0" ]]; then
        icon='/usr/share/icons/Papirus-Dark/symbolic/status/audio-volume-muted-symbolic.svg'
    elif [[ "$current" -le "30" ]]; then
        icon='/usr/share/icons/Papirus-Dark/symbolic/status/audio-volume-low-symbolic.svg'
    elif [[ "$current" -le "60" ]]; then
        icon='/usr/share/icons/Papirus-Dark/symbolic/status/audio-volume-medium-symbolic.svg'
    elif [[ "$current" -le "90" ]]; then
        icon='/usr/share/icons/Papirus-Dark/symbolic/status/audio-volume-high-symbolic.svg'
    else
        icon='/usr/share/icons/Papirus-Dark/symbolic/status/audio-volume-overamplified-symbolic.svg'
    fi
}

# Основные функции управления звуком
up_volume() {
    pamixer -i 2 --unmute
    get_icon
    dunstify -u low --replace=69 -i "$icon" "Volume : $(get_volume)%"
}

down_volume() {
    pamixer -d 2 --unmute
    get_icon
    dunstify -u low --replace=69 -i "$icon" "Volume : $(get_volume)%"
}

toggle_mute() {
    if pamixer --get-mute | grep -q "true"; then
        pamixer --unmute
        get_icon
        dunstify -u low --replace=69 -i "$icon" "Unmute"
    else
        pamixer --mute
        dunstify -u low --replace=69 -i '/usr/share/icons/Papirus-Dark/symbolic/status/audio-volume-muted-symbolic.svg' "Mute"
    fi
}

# Обработка аргументов
case "$1" in
    "--get") get_volume ;;
    "--up") up_volume ;;
    "--down") down_volume ;;
    "--toggle") toggle_mute ;;
    *) get_volume ;;
esac
```

## Принцип работы
1. **Управление звуком** через `pamixer`:
   - Изменение громкости с шагом 2%
   - Мьютирование/анмьютирование
   - Получение текущего уровня

2. **Визуальные уведомления** через `dunstify`:
   - Динамические иконки из темы Papirus-Dark
   - Замена предыдущих уведомлений (ID=69)
   - Разные иконки для уровней громкости:
     - 0%: 🔇
     - 1-30%: 🔈
     - 31-60%: 🔉
     - 61-90%: 🔊
     - 91-100%: 🎛️

3. **Аргументы командной строки**:
   - `--get` - текущая громкость
   - `--up`/`--down` - регулировка
   - `--toggle` - переключение мьюта

## Установка зависимостей для Arch Linux
```bash
sudo pacman -S pamixer dunst papirus-icon-theme
```

## Интеграция с системой
1. Сделать скрипт исполняемым:
```bash
chmod +x ~/.local/bin/volume
```

2. Настройка горячих клавиш (пример для i3wm):
```config
bindsym XF86AudioRaiseVolume exec --no-startup-id ~/.local/bin/volume --up
bindsym XF86AudioLowerVolume exec --no-startup-id ~/.local/bin/volume --down
bindsym XF86AudioMute exec --no-startup-id ~/.local/bin/volume --toggle
```

## Возможные проблемы и решения
1. **Отсутствие иконок**:
   ```bash
   yay -S papirus-icon-theme  # Установка из AUR
   ```

2. **Не работает dunst**:
   ```bash
   systemctl --user enable --now dunst.service
   ```

3. **Шаг изменения громкости** (редактировать значения `-i 2` и `-d 2`):
   ```bash
   # Изменить на 5%
   pamixer -i 5
   ```

## Дополнительные улучшения
1. Добавить проверку зависимостей:
```bash
check_deps() {
    command -v pamixer >/dev/null || { echo "Install pamixer"; exit 1; }
    command -v dunstify >/dev/null || { echo "Install dunst"; exit 1; }
}
```

2. Поддержка пользовательских путей к иконкам:
```bash
ICON_PATH="${ICON_PATH:-/usr/share/icons/Papirus-Dark}"
```

3. Автоматическое определение максимальной громкости:
```bash
MAX_VOLUME=$(pamixer --get-volume-hardware)
```

Скрипт идеально подходит для использования в минималистичных окружениях рабочего стола (i3, Sway, Openbox) и может быть интегрирован в любую Arch-систему с PulseAudio.