# Устранение неполадок

## Polybar не показывает батарею

- Проверьте имя батареи:
    ```bash
    ls /sys/class/power_supply/
    ```
- Обновите `~/.config/polybar/config.ini`, заменив `BAT0` на ваше имя батареи.
- Перезапустите Polybar:
    ```bash
    polybar-msg cmd restart
    ```

## Анимации тормозят

- Закомментируйте `picom &` в `~/.config/bspwm/bspwmrc`:
    ```bash
    # picom &
    ```
- Или настройте `~/.config/picom/picom.conf` для меньшей нагрузки (например, уменьшите `shadow-radius` или отключите `fade`).

## Скрипты или обои не работают

- Убедитесь, что `~/.local/bin` в `$PATH`:
    ```bash
    echo $PATH
    ```
    
    Если отсутствует, добавьте в `~/.bashrc`:
    
    ```bash
    export PATH="$HOME/.local/bin:$PATH"
    ```
    
    Или в `~/.config/fish/config.fish`:
    
    ```bash
    set -gx PATH $HOME/.local/bin $PATH
    ```
    
- Проверьте права доступа:
    
    ```bash
    chmod -R +x ~/.local/bin
    ls -l ~/Images
    ```
    

## Обои не меняются через random_wallpaper

- Убедитесь, что обои скопированы в `~/Images`:
    
    ```bash
    ls ~/Images
    ```
    
- Проверьте, что `feh` установлен:
    
    ```bash
    pacman -Qs feh
    ```
    
- Проверьте путь в `random_wallpaper`:
    
    ```bash
    cat ~/.local/bin/random_wallpaper
    ```
    
    Убедитесь, что он указывает на `~/Images`.

## Уведомления Dunst не отображаются

- Проверьте, запущен ли Dunst:
    
    ```bash
    pgrep dunst
    ```
    
- Если не запущен, добавьте в `~/.config/bspwm/bspwmrc`:
    
    ```bash
    dunst &
    ```
    
- Проверьте конфигурацию `~/.config/dunst/dunstrc`.

## Шрифты отображаются некорректно

- Убедитесь, что шрифты установлены:
    
    ```bash
    ls ~/.local/share/fonts/
    fc-cache -fv
    ```
    
- Проверьте, что шрифты указаны правильно в `~/.config/polybar/config.ini` или `~/.config/rofi/config.rasi` (например, `JetBrainsMono Nerd Font`).

## Скрипты ytd, ytd_audio, ytd_video не работают

- Убедитесь, что `yt-dlp` и `ffmpeg` установлены:
    
    ```bash
    pacman -Qs yt-dlp ffmpeg
    ```
    
- Обновите `yt-dlp`:
    
    ```bash
    yt-dlp -U
    ```
    

## Проблемы с Wi-Fi (wifimenu)

- Проверьте, установлен ли `networkmanager`:
    
    ```bash
    pacman -Qs networkmanager
    ```
    
- Убедитесь, что `nmcli` работает:
    
    ```bash
    nmcli device wifi list
    ```
    

## BSPWM не запускается

- Проверьте `~/.xinitrc`:
    
    ```bash
    cat ~/.xinitrc
    ```
    
    Убедитесь, что последняя строка — `exec bspwm`.
- Проверьте права `bspwmrc`:
    
    ```bash
    chmod +x ~/.config/bspwm/bspwmrc
    ```
    

## Дополнительная помощь

- Проверьте логи X11:
    
    ```bash
    cat ~/.xsession-errors
    ```
    
- Обратитесь к документации скриптов в `scripts/docs/` или создайте issue на [GitHub](https://github.com/PDTPLR/Linux/issues).
