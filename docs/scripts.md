# 📜 Описание скриптов

Этот документ описывает скрипты в папках scripts/utils/, scripts/color-scripts/ и scripts/fetchs/ репозитория [PDTPLR/Linux](https://github.com/PDTPLR/Linux). Все скрипты копируются в `~/.local/bin/` при установке.

---

## 🛠 Скрипты утилит (scripts/utils/)

- **battery-alert**: Уведомляет о низком заряде батареи.
    
    ```bash
    ~/.local/bin/battery-alert
    ```
    
    Настройте имя батареи в скрипте (см. troubleshooting.md).
    
- **bluetooth_menu.sh**: Управление Bluetooth-устройствами.
    
    ```bash
    ~/.local/bin/bluetooth_menu.sh
    ```
    
- **brightness**: Регулировка яркости экрана.
    
    ```bash
    ~/.local/bin/brightness up
    ~/.local/bin/brightness down
    ```
    
- **wifimenu**: Подключение к Wi-Fi через `nmcli`.
    
    ```bash
    ~/.local/bin/wifimenu
    ```
    
- **random_wallpaper**: Случайный выбор обоев из `~/Images`.
    
    ```bash
    ~/.local/bin/random_wallpaper
    ```
    
    Горячая клавиша: `Super + W`.
    
- **show-keybindings.sh**: Отображает горячие клавиши.
    
    ```bash
    ~/.local/bin/show-keybindings.sh
    ```
    
- **xcolor-pick**: Выбор цвета на экране.
    
    ```bash
    ~/.local/bin/xcolor-pick
    ```
    
    Горячая клавиша: `Super + Shift + X`.
    
- **ytd, ytd_audio, ytd_video**: Загрузка видео/аудио с YouTube через `yt-dlp`.
    
    ```bash
    ~/.local/bin/ytd <URL>
    ~/.local/bin/ytd_audio <URL>
    ~/.local/bin/ytd_video <URL>
    ```
    

---

## 🎨 Цветовые скрипты (scripts/color-scripts/)

- Скрипты для визуализации цветовых палитр в терминале.
- Пример использования:
    
    ```bash
    ~/.local/bin/<color_script>
    ```
    
- Список скриптов: `ls ~/.local/bin | grep color`.

---

## 📊 Fetch-скрипты (scripts/fetchs/)

- Скрипты для вывода системной информации (CPU, RAM, дистрибутив и т.д.).
- Пример использования:
    
    ```bash
    ~/.local/bin/<fetch_script>
    ```
    
- Список скриптов: `ls ~/.local/bin | grep fetch`.

---

## 📝 Документация скриптов

Подробное описание каждого скрипта (если доступно) находится в scripts/docs/. Например:

- scripts/docs/Battery-alert.md.

---

## ⚠ Примечания

- Убедитесь, что `~/.local/bin` в `PATH`:
    
    ```bash
    echo $PATH
    ```
    
    Если отсутствует, добавьте в `~/.bashrc`:
    
    ```bash
    export PATH="$HOME/.local/bin:$PATH"
    ```
    
- Проверьте права доступа:
    
    ```bash
    chmod -R +x ~/.local/bin
    ```
    
- Если скрипты не работают, смотрите troubleshooting.md.
