# Установка BSPWM Dotfiles

## Arch Linux

1. Клонируйте репозиторий:
    ```bash
    git clone https://github.com/PDTPLR/Linux.git
    cd Linux
    ```
    
2. Запустите скрипт установки:
    ```bash
    chmod +x scripts/install.sh
    ./scripts/install.sh
    ```
    > **Примечание**: Скрипт устанавливает пакеты из `packages.txt`, копирует конфигурации в `~/.config/`, скрипты в `~/.local/bin/`, обои в `~/Images`.

3. Запустите BSPWM:
    ```bash
    startx
    ```

## Ubuntu/Debian

1. Клонируйте репозиторий (см. шаг 1 для Arch).
2. Запустите скрипт:
    ```bash
    chmod +x scripts/install.sh
    ./scripts/install.sh
    ```
    > **Примечание**: Некоторые пакеты (например, `yay`, `*-nerd`) недоступны в Ubuntu. Установите эквиваленты вручную (например, `fonts-dejavu`).

3. Скопируйте обои вручную, если нужно:
    ```bash
    mkdir -p ~/Images
    cp assets/wallpapers/* ~/Images/
    ```

4. Запустите BSPWM:
    ```bash
    startx
    ```
    

## Другие дистрибутивы

- Установите пакеты из `packages.txt` вручную с помощью вашего пакетного менеджера.
- Скопируйте файлы:
    
    ```bash
    cp -r configs/* ~/.config/
    cp .xinitrc .bashrc ~/
    cp -r scripts/utils/* scripts/color-scripts/* scripts/fetchs/* ~/.local/bin/
    chmod -R +x ~/.local/bin
    mkdir -p ~/Images
    cp -r assets/wallpapers/* ~/Images/
    chmod +x ~/.config/bspwm/bspwmrc
    ```
