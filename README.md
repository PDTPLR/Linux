# 🌟 Dotfiles для BSPWM от PDTPLR 🌟

![GitHub stars](https://img.shields.io/github/stars/PDTPLR/Linux?style=social)  
![GitHub license](https://img.shields.io/github/license/PDTPLR/Linux)

Добро пожаловать в мои dotfiles! Это минималистичная и настраиваемая настройка BSPWM для Arch Linux с частичной поддержкой Ubuntu/Debian. Она создана для всех, кто ценит простоту, производительность и эстетику. 🌈

📖 **О проекте**

Лёгкое окружение для работы и творчества, адаптированное для разных пользователей и устройств.

- **ОС**: Arch Linux (основная), Ubuntu/Debian (частичная поддержка).
- **Оконный менеджер**: BSPWM (configs/bspwm/).
- **Панель**: Polybar (configs/polybar/).
- **Композитор**: Picom (configs/picom/).
- **Терминал**: Alacritty.
- **Лаунчер**: Rofi (configs/rofi/).
- **Уведомления**: Dunst (configs/dunst/).
- **Оболочка**: Fish (configs/fish/).

🖼 **Галерея**

![Рабочий стол](screenshots/bspwm.png)  
![Polybar](screenshots/btop.png)  
![Rofi](screenshots/ranger.png)

> 📌 **Примечание**: Добавьте свои скриншоты в папку screenshots/ и обновите пути выше.

✨ **Особенности**

- **Гибкость**: Конфигурации для BSPWM, Polybar, Rofi и других инструментов легко настраиваются (configs/).
- **Обои**: 63 изображения для динамической смены фона (assets/wallpapers/).
- **Шрифты**: Nerd Fonts для иконок и терминалов (assets/fonts/).
- **Скрипты**: Утилиты для управления системой, обоями, Wi-Fi и цветами (scripts/utils/, scripts/color-scripts/, scripts/fetchs/).
- **Горячие клавиши**: Оптимизированы для удобства (configs/sxhkd/sxhkdrc).
- **Лёгкость**: Система потребляет менее 700 МБ памяти.
- **Автоматизация**: Установка через `install.sh` (scripts/install.sh) или интерактивный `install.py` (scripts/install.py).
- **Инклюзивность**: Поддержка разных разрешений экрана и дистрибутивов, документация для новичков (docs/).

🌍 **Для всех пользователей**

Мы стремимся сделать проект доступным:

- Поддержка разных разрешений экрана (не только 1920x1080).
- Инструкции для Arch Linux и Ubuntu/Debian.
- Подробная документация на русском языке (docs/installation.md, docs/troubleshooting.md).
- Возможность сообщить об ошибках через [Issues](https://github.com/PDTPLR/Linux/issues).

⚠ **Важно**

Конфигурация оптимизирована для Arch Linux и экранов 1920x1080, но работает на других разрешениях и дистрибутивах с небольшими настройками. Если что-то не работает, проверьте docs/troubleshooting.md или напишите в [Issues](https://github.com/PDTPLR/Linux/issues).

📦 **Установка**

### Быстрая установка (install.sh)

1. Клонируйте репозиторий:
    
    ```bash
    git clone https://github.com/PDTPLR/Linux.git
    cd Linux
    ```
    
2. Запустите скрипт:
    
    ```bash
    chmod +x scripts/install.sh
    ./scripts/install.sh
    ```
    
    > Устанавливает пакеты, копирует конфигурации, скрипты, обои, шрифты, настраивает `.xinitrc` и `PATH`.
    
3. Запустите BSPWM:
    
    ```bash
    startx
    ```
    

### Интерактивная установка (install.py)

1. Клонируйте репозиторий (см. выше).
2. Запустите скрипт с меню:
    
    ```bash
    chmod +x scripts/install.py
    ./scripts/install.py
    ```
    
    > Выберите, что установить: пакеты, конфигурации, скрипты, обои, шрифты, `.xinitrc`, `PATH`.
    
3. Запустите BSPWM:
    
    ```bash
    startx
    ```
    

Подробности: docs/installation.md.

🛠 **После установки**

Если возникли проблемы, смотрите docs/troubleshooting.md. Основные случаи:

- **Батарея не отображается в Polybar**: Проверьте имя батареи (`ls /sys/class/power_supply/`) и обновите `~/.local/bin/battery-alert` и `~/.config/polybar/config.ini`.
- **Анимации тормозят**: Закомментируйте `picom &` в `~/.config/bspwm/bspwmrc` или настройте `~/.config/picom/picom.conf`.
- **Обои не меняются**: Убедитесь, что `feh` установлен и обои в `~/Images` (проверьте `~/.local/bin/random_wallpaper`).
- **Шрифты некорректны**: Проверьте `~/.local/share/fonts/` и выполните `fc-cache -fv`.

🎹 **Горячие клавиши**

- Открыть терминал: `Super + Enter`
- Случайные обои: `Super + W`
- Смена раскладки: `Shift + Alt`
- Меню приложений (Rofi): `Super + D`
- Блокировка экрана: `Super + Shift + L`
- Выбор цвета на экране: `Super + Shift + X`
- Переключение Polybar: `Super + Shift + P`
- Плавающий режим окна: `Super + Space`
- Закрыть окно: `Super + C`
- Переключение рабочих столов: `Super + 1-9`
- Переместить окно на стол: `Super + Shift + 1-9`
- Перезапуск BSPWM: `Ctrl + Shift + R`
- Снимок экрана: `Print`

Полный список: configs/sxhkd/sxhkdrc. Используйте `~/.local/bin/show-keybindings.sh` для просмотра.

🤝 **Как помочь проекту**

1. Сделайте форк репозитория.
2. Создайте ветку: `git checkout -b feature/ваша-идея`.
3. Внесите изменения: `git commit -m "Добавлена идея"`.
4. Запушьте: `git push origin feature/ваша-идея`.
5. Откройте Pull Request: [Pull Requests](https://github.com/PDTPLR/Linux/pulls).

Сообщайте об ошибках или идеях в [Issues](https://github.com/PDTPLR/Linux/issues).

📜 **Лицензия**

MIT License

