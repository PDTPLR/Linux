## Исходный код
```bash
#!/usr/bin/env bash

# Уведомления через notify-send
notify="notify-send"

# Пути для временных файлов
tmp_disturb="/tmp/xmonad/donotdisturb"
tmp_disturb_colorfile="$tmp_disturb/color"

# Создание директории при необходимости
[ ! -d "$tmp_disturb" ] && mkdir -p "$tmp_disturb"

# Основная логика переключения режима
case $(dunstctl is-paused) in
    "true")   # Режим "Не беспокоить" активен
        dunstctl set-paused false
        $notify "Режим уведомлений: ВКЛ" "Все уведомления активированы"
        echo "#84afdb" > "$tmp_disturb_colorfile"  # Синий цвет
        ;;
    "false")  # Режим обычных уведомлений
        $notify "Режим уведомлений: ВЫКЛ" "Уведомления отключены на 3 секунды"
        echo "#c47eb7" > "$tmp_disturb_colorfile"  # Фиолетовый цвет
        (sleep 3 && dunstctl close && dunstctl set-paused true) &
        ;;
esac
```

---

## Подробное объяснение работы скрипта

### 1. Назначение
Скрипт управляет режимом "Не беспокоить" для уведомлений через Dunst:
- Переключает состояние уведомлений
- Визуальная обратная связь через:
  - Системные уведомления
  - Цветовую индикацию (для интеграции в статус-бар)

### 2. Ключевые компоненты

#### 2.1 Переменные окружения
```bash
notify="notify-send"  # Утилита для отправки уведомлений
tmp_disturb="/tmp/xmonad/donotdisturb"  # Временная директория
tmp_disturb_colorfile="$tmp_disturb/color"  # Файл с цветом статуса
```

#### 2.2 Работа с файловой системой
```bash
[ ! -d "$tmp_disturb" ] && mkdir -p "$tmp_disturb"
```
- Создает директорию при первом запуске
- Хранит состояние в `/tmp` (автоматически очищается при перезагрузке)

#### 2.3 Логика переключения
```bash
case $(dunstctl is-paused) in
  "true")   # Деактивация режима
    dunstctl set-paused false
    ...
  "false")  # Активация режима
    ...
    (sleep 3 && ... set-paused true) &
```
- Использует официальный интерфейс управления Dunst
- Задержка 3 секунды перед активацией режима

### 3. Особенности реализации
- **Цветовые коды** HEX для интеграции с панелью (XMonad/Polybar)
- **Фоновый процесс** для задержки активации режима
- **Автоматическое закрытие** последнего уведомления через `dunstctl close`

---

## Установка и настройка для Arch Linux

### 1. Установка зависимостей
```bash
sudo pacman -S dunst libnotify  # Основные компоненты
```

### 2. Интеграция с XMonad
Добавить в статус-бар (пример для xmobar):
```haskell
Run Com "/tmp/xmonad/donotdisturb/color" [] "dnd" 600
```

### 3. Настройка горячих клавиш
Для i3wm в `~/.config/i3/config`:
```ini
bindsym $mod+Shift+n exec --no-startup-id ~/bin/do_not_disturb.sh
```

---

## Расширенная версия с таймером
```bash
#!/usr/bin/env bash

# Конфигурация
TIMEOUT=300  # 5 минут в секундах
COLOR_ACTIVE="#84afdb"
COLOR_MUTE="#c47eb7"

# Проверка статуса
if [ "$1" = "status" ]; then
    [ "$(dunstctl is-paused)" = "true" ] && echo "$COLOR_MUTE" || echo "$COLOR_ACTIVE"
    exit 0
fi

# Основная логика
if [ "$(dunstctl is-paused)" = "true" ]; then
    dunstctl set-paused false
    notify-send "Уведомления активированы"
    echo "$COLOR_ACTIVE" > "$tmp_disturb_colorfile"
else
    notify-send "Тихий режим" "Уведомления отключены на 5 минут"
    echo "$COLOR_MUTE" > "$tmp_disturb_colorfile"
    (
        sleep $TIMEOUT
        dunstctl set-paused true
        notify-send "Тихий режим отключен"
        echo "$COLOR_ACTIVE" > "$tmp_disturb_colorfile"
    ) &
fi
```

---

## Решение проблем

### 1. Не работают уведомления
- Проверьте статус демона Dunst: `systemctl --user status dunst`
- Убедитесь в отсутствии конфликтующих демонов уведомлений

### 2. Нет доступа к /tmp
```bash
sudo chmod 1777 /tmp  # Стандартные права для /tmp
```

### 3. Цвет не обновляется
- Убедитесь что статус-бар перечитывает файл
- Проверьте права на файл: `chmod 666 /tmp/xmonad/donotdisturb/color`

---

## Пример интеграции с Polybar
```ini
[module/dnd]
type = custom/script
exec = ~/bin/do_not_disturb.sh status
interval = 1
label = %output%
format-padding = 2
format-foreground = ${colors.foreground}
format-background = ${colors.background}
```

Скрипт предоставляет гибкий механизм управления уведомлениями с визуальной обратной связью, идеально подходящий для минималистичных окружений рабочего стола. Для окружений вроде GNOME/KDE используйте штатные средства управления уведомлениями.