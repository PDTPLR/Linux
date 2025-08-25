#!/bin/bash

FLAG_FILE=/tmp/bspwm_floating_mode

# Функция для настройки тачпада (включаем drag-and-drop и middle emulation)
setup_touchpad() {
  # Находим ID тачпада
  TOUCHPAD_ID=$(xinput list | grep -i touchpad | grep -o 'id=[0-9]*' | cut -d'=' -f2)
  if [ -n "$TOUCHPAD_ID" ]; then
    # Включаем tap-to-click, tap-drag, drag и middle emulation
    xinput set-prop "$TOUCHPAD_ID" "libinput Tapping Enabled" 1
    xinput set-prop "$TOUCHPAD_ID" "libinput Tapping Drag Enabled" 1
    xinput set-prop "$TOUCHPAD_ID" "libinput Drag Enabled" 1
    xinput set-prop "$TOUCHPAD_ID" "libinput Middle Emulation Enabled" 1
  fi
}

if [ -f "$FLAG_FILE" ]; then
  # Переключаем обратно в tiling mode
  rm "$FLAG_FILE"
  bspc rule -r "*"  # Удаляем правило для floating
  # Устанавливаем все открытые окна в tiled
  bspc query -N | xargs -I id bspc node id -t tiled
  # Восстанавливаем настройки мыши из bspwmrc (mod4 = Super)
  bspc config pointer_modifier mod4
  bspc config pointer_action1 move
  bspc config pointer_action2 resize_side
  bspc config pointer_action3 resize_corner
  # Возобновляем libinput-gestures
  pkill -f libinput-gestures
  libinput-gestures &
  notify-send "BSPWM" "Tiling mode enabled" -t 2000
else
  # Переключаем в floating mode
  touch "$FLAG_FILE"
  bspc rule -a "*" state=floating  # Все новые окна будут floating
  # Устанавливаем все открытые окна в floating
  bspc query -N | xargs -I id bspc node id -t floating
  # Устанавливаем pointer_modifier на mod1 (Alt) для macOS-подобного поведения
  bspc config pointer_modifier mod1
  bspc config pointer_action1 move
  bspc config pointer_action2 resize_side
  bspc config pointer_action3 resize_corner
  # Отключаем libinput-gestures, чтобы не мешали перетаскиванию
  pkill -f libinput-gestures
  # Настраиваем тачпад для drag-and-drop
  setup_touchpad
  notify-send "BSPWM" "Floating mode enabled (use Alt to move/resize)" -t 2000
fi
