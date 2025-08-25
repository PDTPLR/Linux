#!/bin/bash

# Путь к теме Rofi
ROFI_THEME="$HOME/.config/rofi/config.rasi"

# Создаем список комбинаций в простом формате
keybindings=$(cat << 'EOF'
super + Escape + r: Перезагрузка конфигурации sxhkd
super + Return: Запуск терминала Alacritty
super + p: Скрыть/показать Polybar
super + w: Установить случайные обои
Alt_L + shift: Смена языка ввода
ctrl + space: Смена языка ввода
super + d: Запуск Rofi (drun)
super + x: Запуск меню питания
super + shift + f: Запуск Firefox
super + shift + n: Запуск Thunar
super + shift + o: Запуск Obsidian
super + shift + t: Запуск Telegram
super + shift + c: Запуск VSCodium
super + shift + x: Запуск xcolor-pick
super + shift + k: Запуск Calcurse
super + shift + l: Блокировка экрана
ctrl + super + alt + k: Закрытие окна (xkill)
XF86AudioRaiseVolume: Увеличить громкость
XF86AudioLowerVolume: Уменьшить громкость
XF86AudioMute: Выключить/включить звук
XF86MonBrightnessUp: Увеличить яркость
XF86MonBrightnessDown: Уменьшить яркость
Print: Скриншот (Flameshot)
ctrl + shift + q: Выход из bspwm
ctrl + shift + r: Перезапуск bspwm
super + c: Закрытие текущего окна
super + alt + f: Переключение floating/tiling режима
super + shift + 7: Показать горячие клавиши
super + f: Переключение полноэкранного режима
alt + Tab: Фокус на следующее окно
alt + shift + Tab: Фокус на предыдущее окно
super + grave: Фокус на последнее окно
super + Tab: Фокус на последний рабочий стол
super + 1-9,0: Переключение на рабочий стол 1-10
super + shift + 1-9,0: Отправить окно на рабочий стол 1-10
super + ctrl + 1-9: Установить соотношение предвыбора
super + ctrl + space: Отменить предвыбор
super + ctrl + shift + space: Сбросить предвыбор для всех окон
super + control + j/l/i/k: Изменить размер окна
super + j/l/i/k: Переместить фокус
super + alt + j/l/i/k: Переместить окно
super + ctrl + m/x/y/z: Установить флаги окна
super + ctrl + Left/Right: Переключение между рабочими столами
super + shift + Left/Right: Переместить окно на другой рабочий стол
EOF
)

# Запускаем Rofi с одноколоночным списком
echo "$keybindings" | rofi -dmenu -i -p "Горячие клавиши" \
    -theme "$ROFI_THEME" \
    -no-fixed-num-lines \
    -columns 1 \
    -width 3200 \
    -theme-str 'listview { columns: 1; }'
