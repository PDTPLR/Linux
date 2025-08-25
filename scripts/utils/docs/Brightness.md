## Исходный код
```bash
#!/usr/bin/env bash

# Определение графического адаптера
CARD=$(basename "$(find /sys/class/backlight/* -maxdepth 0 | head -n 1)")

# Получение текущей яркости
get_backlight() {
    if [[ "$CARD" == *"intel_"* ]]; then
        xbacklight -get | awk '{printf "%.0f", $1}'
    else
        light -G | awk '{printf "%.0f", $1}'
    fi
}

# Увеличение яркости
inc_backlight() {
    if [[ "$CARD" == *"intel_"* ]]; then
        xbacklight -inc 5 -steps 5
    else
        light -A 5
    fi
    notify-send "Яркость: $(get_backlight)%" -t 1000 -h int:value:$(get_backlight)
}

# Уменьшение яркости
dec_backlight() {
    if [[ "$CARD" == *"intel_"* ]]; then
        xbacklight -dec 5 -steps 5
    else
        light -U 5
    fi
    notify-send "Яркость: $(get_backlight)%" -t 1000 -h int:value:$(get_backlight)
}

# Обработка аргументов
case "$1" in
    "--get")    get_backlight ;;
    "--up")     inc_backlight ;;
    "--down")   dec_backlight ;;
    *)          get_backlight ;;
esac
```

---

## Подробное объяснение работы скрипта

### 1. Определение графического адаптера
```bash
CARD=$(basename "$(find /sys/class/backlight/* -maxdepth 0 | head -n 1)")
```
- Ищет первый доступный контроллер подсветки в `/sys/class/backlight`
- Примеры значений:
  - `intel_backlight` - интегрированная графика Intel
  - `amdgpu_bl0` - графика AMD
  - `nvidia_0` - дискретная NVIDIA

### 2. Управление яркостью
Для разных типов адаптеров используются разные утилиты:
- **Intel** - `xbacklight`
- **Остальные** - `light`

### 3. Функции управления
#### 3.1 Получение текущей яркости
```bash
get_backlight() {
    # Возвращает значение от 0 до 100
}
```

#### 3.2 Изменение яркости
```bash
inc_backlight()  # +5%
dec_backlight()  # -5%
```
- Плавное изменение с шагами (`-steps 5`)
- Визуальное уведомление через `notify-send`

### 4. Установка зависимостей для Arch Linux
```bash
sudo pacman -S xorg-xbacklight light libnotify
```

### 5. Настройка прав
Добавить пользователя в группу `video`:
```bash
sudo usermod -aG video $USER
```

---

## Интеграция с системой

### 1. Горячие клавиши в i3wm
```ini
# ~/.config/i3/config
bindsym XF86MonBrightnessUp exec --no-startup-id ~/scripts/brightness --up
bindsym XF86MonBrightnessDown exec --no-startup-id ~/scripts/brightness --down
```

### 2. Автоматический запуск служб
```bash
# /etc/udev/rules.d/90-backlight.rules
ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"
ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
```

---

## Расширенная версия с проверками
```bash
#!/usr/bin/env bash

# Проверка доступности управления яркостью
check_backlight() {
    if ! [ -d /sys/class/backlight ]; then
        echo "Error: No backlight interface found" >&2
        exit 1
    fi
}

# Получение максимальной яркости
get_max_brightness() {
    cat "/sys/class/backlight/$CARD/max_brightness"
}

# Нормализация значения
normalize_brightness() {
    local current=$(get_backlight)
    local max=$(get_max_brightness)
    echo $((current * 100 / max))
}

check_backlight

case "$1" in
    "--get")    normalize_brightness ;;
    "--up")     inc_backlight ;;
    "--down")   dec_backlight ;;
    *)          normalize_brightness ;;
esac
```

---

## Решение проблем

### 1. Нет доступа к яркости
```bash
sudo chmod 666 /sys/class/backlight/*/brightness
```

### 2. Не работает xbacklight
Проверьте настройки Xorg:
```bash
Section "Device"
    Identifier  "Intel Graphics"
    Driver      "intel"
    Option      "Backlight" "intel_backlight"
EndSection
```

### 3. Мерцание уведомлений
```bash
notify-send "Яркость" "$(get_backlight)%" -t 500 -h int:transient:1
```

---

## Альтернативные методы управления
### 1. Через sysfs напрямую
```bash
echo 500 | sudo tee /sys/class/backlight/intel_backlight/brightness
```

### 2. Использование ddccontrol для внешних мониторов
```bash
yay -S ddccontrol
ddccontrol -r 0x10 -w 50 dev:/dev/i2c-3
```

Скрипт обеспечивает универсальное управление яркостью для разных графических адаптеров. Для ноутбуков с гибридной графикой рекомендуется дополнительная настройка через optimus-manager.
