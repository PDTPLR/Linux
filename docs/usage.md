# 📚 Использование Dotfiles

Этот документ объясняет, как использовать окружение BSPWM из [PDTPLR/Linux](https://github.com/PDTPLR/Linux) после установки. Смотрите также installation.md и troubleshooting.md.

---

## 🚀 Запуск BSPWM

1. Убедитесь, что установлены все зависимости (packages.txt).
2. Запустите BSPWM:
    
    ```bash
    startx
    ```
    

---

## 🖼 Смена обоев

- Используйте скрипт scripts/utils/random_wallpaper:
    
    ```bash
    ~/.local/bin/random_wallpaper
    ```
    
- Горячая клавиша: `Super + W`.
- Обои хранятся в `~/Images` (копируются из assets/wallpapers/).

---

## 🎹 Управление горячими клавишами

- Основные горячие клавиши см. в hotkeys.md.
- Просмотрите их с помощью:
    
    ```bash
    ~/.local/bin/show-keybindings.sh
    ```
    
- Настройте в configs/sxhkd/sxhkdrc.

---

## 🛠 Управление Polybar

- Перезапустите Polybar:
    
    ```bash
    polybar-msg cmd restart
    ```
    
- Переключение видимости: `Super + Shift + P`.
- Настройте модули в configs/polybar/config.ini.

---

## 📡 Управление сетью

- Используйте scripts/utils/wifimenu для подключения к Wi-Fi:
    
    ```bash
    ~/.local/bin/wifimenu
    ```
    

---

## 🔤 Настройка шрифтов

- Шрифты из assets/fonts/ копируются в `~/.local/share/fonts/`.
- Обновите кэш шрифтов:
    
    ```bash
    fc-cache -fv
    ```
    

---

## 🔔 Настройка уведомлений

- Убедитесь, что Dunst запущен:
    
    ```bash
    pgrep dunst
    ```
    
- Настройте в configs/dunst/dunstrc.

---

## 📜 Полезные команды

- Проверка системной информации:
    
    ```bash
    ~/.local/bin/<fetch_script>
    ```
    
    Список скриптов: scripts/fetchs/.
- Управление яркостью:
    
    ```bash
    ~/.local/bin/brightness
    ```
    
- Выбор цвета на экране:
    
    ```bash
    ~/.local/bin/xcolor-pick
    ```
    

Смотрите scripts.md для полного описания скриптов.
