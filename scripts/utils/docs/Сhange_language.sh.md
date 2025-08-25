## Исходный код
```bash
#!/bin/bash

# Получение текущей раскладки
CURRENT_LAYOUT=$(setxkbmap -query | awk -F : 'NR==3{print $2}' | sed 's/ //g')

# Переключение раскладки и уведомление
if [ "$CURRENT_LAYOUT" = "us" ]; then
    setxkbmap "ru"
    notify-send "⌨️ Язык ввода: RU" -t 700 -i input-keyboard
else
    setxkbmap "us" 
    notify-send "⌨️ Input Language: US" -t 700 -i input-keyboard
fi
```

---

## Подробное объяснение работы скрипта

### 1. Определение текущей раскладки
```bash
CURRENT_LAYOUT=$(setxkbmap -query | awk -F : 'NR==3{print $2}' | sed 's/ //g')
```
- `setxkbmap -query` выводит текущие настройки клавиатуры
- `awk` извлекает 3-ю строку (раскладку) и разделяет по `:`
- `sed` удаляет пробелы для чистого значения

Пример вывода:
```
rules:      evdev
model:      pc105
layout:     us,ru
```

### 2. Логика переключения
```bash
if [ "$CURRENT_LAYOUT" = "us" ]; then
    setxkbmap "ru"
else
    setxkbmap "us"
fi
```
- Если текущая раскладка US → переключаем на RU
- В противном случае → переключаем на US

### 3. Визуальные уведомления
```bash
notify-send "⌨️ Язык ввода: RU" -t 700 -i input-keyboard
```
- `-t 700` - время показа 700 мс
- `-i input-keyboard` - иконка клавиатуры
- Поддержка эмодзи (⌨️)

---

## Установка зависимостей для Arch Linux

### 1. Основные пакеты
```bash
sudo pacman -S xorg-setxkbmap libnotify
```

### 2. Дополнительные иконки
```bash
sudo pacman -S hicolor-icon-theme
```

### 3. Проверка работы
```bash
chmod +x Change_language.sh
./Change_language.sh
```

---

## Интеграция с системой

### 1. Для i3wm (~/.config/i3/config)
```ini
bindsym $mod+space exec --no-startup-id ~/scripts/Change_language.sh
```

### 2. Для sxhkd (~/.config/sxhkd/sxhkdrc)
```ini
super + space
    ~/scripts/Change_language.sh
```

### 3. Автозагрузка раскладки
Добавить в ~/.xprofile:
```bash
setxkbmap -layout us,ru -option grp:caps_toggle
```

---

## Возможные улучшения

### 1. Добавить индикатор в статус-бар
```bash
# Получить текущую раскладку
current_layout=$(setxkbmap -query | awk '/layout:/{print $2}' | cut -d, -f1)
echo "LANG: $current_layout"
```

### 2. Звуковое сопровождение
```bash
paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga
```

### 3. Проверка ошибок
```bash
if ! setxkbmap -layout "$new_layout"; then
    notify-send "Ошибка переключения!" -u critical
    exit 1
fi
```

---

## Решение проблем

### 1. Не работает переключение
- Проверьте доступные раскладки: `localectl list-x11-keymap-layouts`
- Убедитесь что X-сервер запущен

### 2. Нет уведомлений
- Проверьте демон уведомлений: `systemctl --user status dunst`
- Установите тему иконок: `sudo pacman -S papirus-icon-theme`

### 3. Медленное переключение
- Используйте более легковесные решения:
  ```bash
  yay -S xkb-switch
  xkb-switch -n
  ```

---

## Альтернативные методы

### 1. Через xkb-switch
```bash
sudo pacman -S xkb-switch
xkb-switch -n && notify-send "Язык: $(xkb-switch)"
```

### 2. С индикатором Caps Lock
```bash
setxkbmap -option grp:caps_toggle us,ru
```

Скрипт обеспечивает быстрое переключение раскладки с визуальной обратной связью, идеально подходит для пользователей, работающих с несколькими языками ввода. Для продвинутого управления раскладками рассмотрите использование fcitx5 или ibus.