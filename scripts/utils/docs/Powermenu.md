## Исходный код
```bash
#!/bin/env bash

# Показать меню выбора через Rofi в два столбца с видимостью всех строк
choice=$(printf "⟢ Lock\n⧴ Logout\n⧻ Suspend\n⧜ Reboot\n⧨ Shutdown" | rofi -dmenu -p "Power Menu:" -columns 2 -lines 5 -theme-str 'window { width: 300px; height: 300px; } listview { columns: 2; lines: 5; margin: 0px; }')

# Обработка выбора
case "$choice" in
  "⟢ Lock") 
    sh "$HOME/bin/screen-lock"
    ;;
  "⧴ Logout") 
    pkill -KILL -u "$USER"
    ;;
  "⧻ Suspend") 
    systemctl suspend && sh "$HOME/bin/screen-lock"
    ;;
  "⧜ Reboot") 
    systemctl reboot
    ;;
  "⧨ Shutdown") 
    systemctl poweroff
    ;;
esac
```

---

## Подробное объяснение работы скрипта

### 1. Запуск меню
```bash
rofi -dmenu -p "Power Menu:"
```
- **Rofi** - утилита для создания меню
- **-dmenu** - режим выпадающего списка
- **-p** - текст приглашения

### 2. Варианты действий
```bash
printf "Lock\nLogout\nSuspend\nReboot\nShutdown"
```
- **Lock** - блокировка экрана
- **Logout** - выход из системы
- **Suspend** - спящий режим
- **Reboot** - перезагрузка
- **Shutdown** - выключение

### 3. Обработка выбора
#### 3.1 Блокировка экрана
```bash
sh "$HOME/bin/screen-lock"
```
- Предполагает наличие скрипта блокировки экрана
- Требует установленного i3lock или аналогичного

#### 3.2 Выход из системы
```bash
pkill -KILL -u "$USER"
```
- Принудительное завершение всех процессов пользователя
- Аналог `loginctl terminate-user $USER`

#### 3.3 Спящий режим
```bash
systemctl suspend && sh "$HOME/bin/screen-lock"
```
- Приостановка системы через systemd
- Автоматическая блокировка после пробуждения

#### 3.4 Перезагрузка/Выключение
```bash
systemctl reboot/poweroff
```
- Использует systemd для управления питанием
- Требует прав суперпользователя (но работает через polkit)

---

## Установка и настройка для Arch Linux

### 1. Установка зависимостей
```bash
sudo pacman -S rofi systemd
```

### 2. Настройка прав
Создайте файл `/etc/polkit-1/rules.d/50-power.rules`:
```javascript
polkit.addRule(function(action, subject) {
  if (action.id == "org.freedesktop.login1.power-off" ||
      action.id == "org.freedesktop.login1.reboot") {
    return polkit.Result.YES;
  }
});
```

### 3. Создание скрипта блокировки
Пример `~/bin/screen-lock`:
```bash
#!/bin/sh
i3lock -n -c 000000
```

### 4. Настройка горячих клавиш
Для i3wm в `~/.config/i3/config`:
```ini
bindsym $mod+Shift+p exec --no-startup-id ~/bin/powermenu
```

---

## Расширенная версия с подтверждением
```bash
#!/bin/env bash

# Параметры Rofi
ROFI_THEME="-theme ~/.config/rofi/power.rasi"
CONFIRM_TIMEOUT=5

# Функция подтверждения
confirm_action() {
  local action="$1"
  printf "Yes\nNo" | rofi -dmenu -p "Confirm $action?" $ROFI_THEME
}

# Главное меню
choice=$(printf "Lock\nLogout\nSuspend\nReboot\nShutdown" | rofi -dmenu -p "Power Menu:" $ROFI_THEME)

case "$choice" in
  "Lock") 
    sh "$HOME/bin/screen-lock" ;;
  
  "Logout") 
    [[ $(confirm_action "Logout") == "Yes" ]] && pkill -KILL -u "$USER" ;;
  
  "Suspend") 
    systemctl suspend && sh "$HOME/bin/screen-lock" ;;
  
  "Reboot") 
    [[ $(confirm_action "Reboot") == "Yes" ]] && systemctl reboot ;;
  
  "Shutdown") 
    [[ $(confirm_action "Shutdown") == "Yes" ]] && systemctl poweroff ;;
esac
```

---

## Решение проблем

### 1. Rofi не запускается
- Проверьте установку: `rofi -v`
- Настройте тему: `mkdir -p ~/.config/rofi/`

### 2. Нет прав на выключение
- Убедитесь что пользователь в группе `wheel`
- Проверьте настройки polkit

### 3. Скрипт блокировки не работает
- Проверьте путь к скрипту
- Убедитесь что i3lock установлен

---

## Пример файла темы Rofi (~/.config/rofi/power.rasi)
```css
configuration {
  font: "Fira Code 12";
  width: 200;
  lines: 5;
}

entry {
  placeholder: "Select action..";
}

listview {
  spacing: 5px;
  padding: 20px;
}
```

Скрипт предоставляет удобный графический интерфейс для управления питанием системы, идеально интегрируясь с минималистичными окружениями рабочего стола. Для окружений вроде GNOME/KDE лучше использовать штатные меню управления питанием.