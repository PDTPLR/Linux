# 🛠 Устранение неполадок

Если что-то не работает после установки [PDTPLR/Linux](https://github.com/PDTPLR/Linux), следуйте этим инструкциям. Сообщайте о проблемах в [Issues](https://github.com/PDTPLR/Linux/issues).

---

## 🔋 Polybar не показывает батарею

- Проверьте имя батареи:
    
    ```bash
    ls /sys/class/power_supply/
    ```
    
- Обновите `~/.local/bin/battery-alert`:
    
    ```bash
    nano ~/.local/bin/battery-alert
    ```
    
    Замените `BAT0` на ваше имя батареи (например, `BAT1`).
- Обновите `[module/battery]` в configs/polybar/config.ini:
    
    ```ini
    [module/battery]
    type = internal/battery
    battery = <ваше_имя_батареи>
    adapter = <ваше_имя_адаптера>
    ```
    
- Перезапустите Polybar:
    
    ```bash
    polybar-msg cmd restart
    ```
    

---

## 🐢 Анимации тормозят

- Закомментируйте запуск `picom` в configs/bspwm/bspwmrc:
    
    ```bash
    # picom &
    ```
    
- Или уменьшите нагрузку в configs/picom/picom.conf:
    
    ```ini
    shadow-radius = 5
    fading = false
    ```
    
- Перезапустите Picom:
    
    ```bash
    pkill picom; picom &
    ```
    

---

## 🖼 Обои не меняются

- Убедитесь, что `feh` установлен:
    
    ```bash
    pacman -Qs feh
    ```
    
- Проверьте наличие обоев:
    
    ```bash
    ls ~/Images
    ```
    
- Проверьте путь в scripts/utils/random_wallpaper:
    
    ```bash
    cat ~/.local/bin/random_wallpaper
    ```
    
    Убедитесь, что он указывает на `~/Images`.

---

## 🔤 Шрифты отображаются некорректно

- Проверьте наличие шрифтов:
    
    ```bash
    ls ~/.local/share/fonts/
    fc-cache -fv
    ```
    
- Убедитесь, что в configs/polybar/config.ini и configs/rofi/config.rasi указан `JetBrainsMono Nerd Font`.

---

## 🔔 Уведомления Dunst не отображаются

- Проверьте, запущен ли Dunst:
    
    ```bash
    pgrep dunst
    ```
    
- Добавьте в configs/bspwm/bspwmrc:
    
    ```bash
    dunst &
    ```
    
- Проверьте configs/dunst/dunstrc.

---

## 📡 Проблемы с Wi-Fi (wifimenu)

- Проверьте `networkmanager`:
    
    ```bash
    pacman -Qs networkmanager
    ```
    
- Проверьте работу `nmcli`:
    
    ```bash
    nmcli device wifi list
    ```
    

---

## 🚫 BSPWM не запускается

- Проверьте ../.xinitrc:
    
    ```bash
    cat ~/.xinitrc
    ```
    
    Последняя строка должна быть `exec bspwm`.
- Проверьте права:
    
    ```bash
    chmod +x ~/.config/bspwm/bspwmrc
    ```
    

---

## 🎥 Скрипты ytd, ytd_audio, ytd_video не работают

- Проверьте наличие `yt-dlp` и `ffmpeg`:
    
    ```bash
    pacman -Qs yt-dlp ffmpeg
    ```
    
- Обновите `yt-dlp`:
    
    ```bash
    yt-dlp -U
    ```
    

---

## 🔍 Другие проблемы

- Проверьте логи X11:
    
    ```bash
    cat ~/.xsession-errors
    ```
    
- Изучите документацию скриптов в scripts/docs/.
- Сообщите об ошибке в [Issues](https://github.com/PDTPLR/Linux/issues).
