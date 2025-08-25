
## Исходный код
```bash
#!/bin/sh
pgrep -x polybar
status=$?
if test $status -eq 0 
then
  killall polybar && bspc config -m focused top_padding 0
else 
  $HOME/.config/polybar/launch.sh && bspc config -m focused top_padding 31
fi
```

## Как работает скрипт

### 1. Проверка состояния Polybar
```bash
pgrep -x polybar
status=$?
```
- `pgrep -x polybar` ищет точное совпадение имени процесса
- `status=$?` сохраняет код возврата:
  - **0** - процесс найден (панель активна)
  - **1** - процесс не найден (панель скрыта)

### 2. Логика переключения
**Если панель активна**:
```bash
killall polybar && bspc config -m focused top_padding 0
```
- Завершает все процессы Polybar
- Убирает верхний отступ в BSPWM (0 пикселей)

**Если панель скрыта**:
```bash
$HOME/.config/polybar/launch.sh && bspc config -m focused top_padding 31
```
- Запускает скрипт инициализации Polybar
- Устанавливает верхний отступ 31px (стандартная высота панели)

## Установка зависимостей
```bash
sudo pacman -S polybar bspwm xdo # Основные компоненты
yay -S siji-git # Популярный шрифт для иконок
```

## Рекомендуемые улучшения
### 1. Безопасная версия скрипта
```bash
#!/bin/bash

# Проверка процессов
if pgrep -x "polybar" >/dev/null; then
    # Закрытие панели
    killall -q polybar
    # Сброс отступов для всех мониторов
    for monitor in $(bspc query -M --names); do
        bspc config -m "$monitor" top_padding 0
    done
else
    # Запуск панели
    "$HOME"/.config/polybar/launch.sh
    # Задержка для инициализации
    sleep 0.5
    # Установка отступов
    for monitor in $(bspc query -M --names); do
        bspc config -m "$monitor" top_padding 31
    done
fi
```

### 2. Что было улучшено:
- Явное указание bash (`#!/bin/bash`)
- Проверка всех мониторов через цикл
- Тихий режим завершения (`-q`)
- Задержка для стабильного запуска
- Обработка путей с пробелами

## Интеграция с BSPWM
Добавьте в `~/.config/bspwm/bspwmrc`:
```bash
# Горячие клавиши для управления
super + p 
    ~/.config/scripts/toggle-polybar
```

## Проблемы и решения
1. **Панель не появляется**:
   - Проверьте путь к launch.sh
   - Убедитесь в наличии прав на выполнение:
     ```bash
     chmod +x ~/.config/polybar/launch.sh
     ```

2. **Неправильные отступы**:
   - Замерьте высоту панели:
     ```bash
     polybar -c ~/.config/polybar/config.ini example 2>&1 | grep "geometry"
     ```

3. **Мерцание при перезапуске**:
   - Добавьте задержку перед установкой отступов:
     ```bash
     sleep 0.3
     ```

## Дополнительные возможности
1. **Анимация отступов**:
```bash
for i in {31..0}; do
    bspc config top_padding $i
    sleep 0.01
done
```

2. **Изменение темы**:
```bash
# Переключение между конфигами
ln -sf ~/.config/polybar/config-${THEME}.ini ~/.config/polybar/config.ini
```

3. **Системтрей**:
```bash
# Проверка доступных модулей
polybar -m | grep tray
```

Скрипт идеально подходит для быстрого управления панелью в оконных менеджерах типа BSPWM. Для окружений рабочего стола (GNOME/KDE) используйте штатные методы управления панелями.