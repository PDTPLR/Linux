## Исходный код
```bash
#!/usr/bin/env bash

## Fullscreen terminal
alacritty --class 'Fullscreen,Fullscreen' \
          -o 'window.padding.x=45' \
          -o 'window.padding.y=45' \
          -o 'window.opacity=1.0'  \
          -o 'window.startup_mode="fullscreen"'
```

## Как работает скрипт
1. **Запуск Alacritty** с особыми параметрами:
   - `--class 'Fullscreen,Fullscreen'` - задаёт класс окна для управления в оконных менеджерах
   - `-o` - переопределение параметров конфигурации "на лету"

2. **Основные настройки**:
   - `window.padding.x=45` - горизонтальные отступы
   - `window.padding.y=45` - вертикальные отступы
   - `window.opacity=1.0` - полная непрозрачность
   - `window.startup_mode="fullscreen"` - запуск в полноэкранном режиме

## Установка зависимостей
```bash
sudo pacman -S alacritty  # Установка терминала
yay -S nerd-fonts-fira-code  # Рекомендуемый шрифт
```

## Интеграция с системой
1. Сделать скрипт исполняемым:
```bash
chmod +x ~/.local/bin/terminal_fullscreen
```

2. Создать ярлык для оконных менеджеров:
```ini
# Для i3wm (~/.config/i3/config)
bindsym $mod+F11 exec --no-startup-id terminal_fullscreen
```

## Решение проблем
1. **Не работает полноэкранный режим**:
   ```bash
   # Проверьте поддержку EWMH в оконном менеджере
   sudo pacman -S xorg-xprop
   xprop -root | grep _NET_SUPPORTED
   ```

2. **Неправильные отступы**:
   ```bash
   # Проверьте текущую конфигурацию Alacritty
   alacritty --print-events | grep "Padding"
   ```

3. **Ошибки прозрачности**:
   Установите композитор:
   ```bash
   sudo pacman -S picom
   picom --experimental-backends &
   ```

## Дополнительные модификации
### 1. Версия с параметрами
```bash
#!/usr/bin/env bash

PADDING=${1:-45}
OPACITY=${2:-1.0}

alacritty --class 'Fullscreen,Fullscreen' \
          -o "window.padding.x=$PADDING" \
          -o "window.padding.y=$PADDING" \
          -o "window.opacity=$OPACITY" \
          -o 'window.startup_mode="fullscreen"'
```

### 2. Автоматическое определение размера
```bash
# Получить разрешение экрана
RES=$(xdpyinfo | awk '/dimensions:/{print $2}')
WIDTH=$(echo $RES | cut -d'x' -f1)
HEIGHT=$(echo $RES | cut -d'x' -f2)

# Рассчитать отступы как 5% от размера
PAD_X=$((WIDTH * 5 / 100))
PAD_Y=$((HEIGHT * 5 / 100))
```

### 3. Темная тема
```bash
-o 'colors.primary.background="#1a1b26"' \
-o 'colors.primary.foreground="#a9b1d6"' \
```

## Советы по использованию
1. Для временного выхода из полноэкранного режима:
   `F11` (стандартная клавиша в Alacritty)

2. Просмотр всех доступных опций:
   ```bash
   alacritty --help | grep -A10 '-o, --option'
   ```

3. Сочетание с tmux:
   ```bash
   -o 'shell.program="tmux"'
   ```

Скрипт идеально подходит для создания "чистого" рабочего пространства при работе в терминале. Может быть адаптирован под любые WM/DE через изменение параметров класса окна.