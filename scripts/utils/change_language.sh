#!/bin/bash

# Получение текущей раскладки
CURRENT_LAYOUT=$(setxkbmap -query | awk -F : 'NR==3{print $2}' | sed 's/ //g')

# Переключение раскладки и уведомление
if [ "$CURRENT_LAYOUT" = "us" ]; then
    setxkbmap "ru"
    notify-send "RU" -t 700 -i input-keyboard
else
    setxkbmap "us" 
    notify-send "US" -t 700 -i input-keyboard
fi
