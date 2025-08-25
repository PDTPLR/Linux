## Исходный код
```bash
#!/bin/bash

# Цветовые настройки
fg=c0caf5       # Основной цвет текста
wrong=db4b4b    # Цвет ошибок
date=7aa2f7     # Цвет даты
verify=7aa2f7   # Цвет подтверждения

# Путь к фоновому изображению
lock_image="$HOME/Images/system/lock_screen.png"

# Запуск i3lock с кастомными настройками
i3lock -n --force-clock \
  -i "$lock_image" \
  -e \
  --indicator \
  --radius=20 \
  --ring-width=40 \
  --inside-color="$fg" \
  --ring-color="$fg" \
  --insidever-color="$verify" \
  --ringver-color="$verify" \
  --insidewrong-color="$wrong" \
  --ringwrong-color="$wrong" \
  --line-uses-inside \
  --keyhl-color="$verify" \
  --separator-color="$verify" \
  --bshl-color="$verify" \
  --time-str="%H:%M" \
  --time-size=140 \
  --date-str="%a, %d %b" \
  --date-size=45 \
  --verif-text="Verifying Password..." \
  --wrong-text="Wrong Password!" \
  --noinput-text="" \
  --greeter-text="Type the password to Unlock" \
  --ind-pos="650:760" \
  --time-font="Fira Code:style=Bold" \
  --date-font="Fira Code" \
  --verif-font="Fira Code" \
  --greeter-font="Fira Code" \
  --wrong-font="Fira Code" \
  --verif-size=23 \
  --greeter-size=23 \
  --wrong-size=23 \
  --time-pos="650:540" \
  --date-pos="650:600" \
  --greeter-pos="650:930" \
  --wrong-pos="650:970" \
  --verif-pos="650:805" \
  --date-color="$date" \
  --time-color="$date" \
  --greeter-color="$fg" \
  --wrong-color="$wrong" \
  --verif-color="$verify" \
  --pointer=default \
  --refresh-rate=0 \
  --pass-media-keys \
  --pass-volume-keys
```

---

## Подробный разбор скрипта

### 1. Цветовые настройки
```bash
fg=c0caf5       # Голубой: основной текст и элементы
wrong=db4b4b    # Красный: сообщения об ошибках
date=7aa2f7     # Синий: дата и время
verify=7aa2f7   # Синий: подсветка подтверждения
```
- HEX-коды цветов в формате RRGGBB
- Можно изменить по желанию через сервисы типа [[ColorHexa]]

### 2. Путь к фоновому изображению
```bash
lock_image="$HOME/Images/system/lock_screen.png"
```
- Требования к изображению:
  - Формат PNG
  - Рекомендуемое разрешение: как у вашего экрана
  - Путь можно изменить на любой другой

### 3. Основные параметры i3lock
| Параметр | Значение | Описание |
|----------|----------|----------|
| `-n` | - | Игнорировать пустые пароли |
| `--force-clock` | - | Всегда показывать часы |
| `-i` | путь к PNG | Фоновое изображение |
| `-e` | - | Игнорировать события мыши |

### 4. Настройка индикатора ввода
```bash
--indicator \
--radius=20 \          # Радиус круга индикатора
--ring-width=40 \      # Толщина кольца
--inside-color="$fg" \ # Цвет внутренней части
--ring-color="$fg" \   # Цвет кольца
```

### 5. Состояния индикатора
| Состояние | Цвета |
|-----------|-------|
| Обычный режим | `--inside-color` + `--ring-color` |
| Проверка пароля | `--insidever-color` + `--ringver-color` |
| Неверный пароль | `--insidewrong-color` + `--ringwrong-color` |

### 6. Текст и шрифты
```bash
--time-str="%H:%M" \           # Формат времени
--date-str="%a, %d %b" \       # Формат даты (Пн, 01 Янв)
--verif-text="Verifying..." \  # Текст проверки
--wrong-text="Wrong Password!" # Текст ошибки
--time-font="Fira Code:style=Bold" # Шрифт времени
```
- Форматы времени/даты: стандартные для `strftime`
- Требуется установленный шрифт **Fira Code**

### 7. Позиционирование элементов
| Элемент | Координаты | Размер |
|---------|------------|--------|
| Индикатор | 650:760 | Радиус 20px |
| Время | 650:540 | 140pt |
| Дата | 650:600 | 45pt |
| Сообщение | 650:930 | 23pt |

### 8. Особые настройки
```bash
--pass-media-keys \   # Разрешить медиа-клавиши
--pass-volume-keys \  # Разрешить клавиши громкости
--refresh-rate=0 \    # Максимальная частота обновления
--pointer=default     # Вид курсора
```

---

## Требования для Arch Linux

### 1. Установка зависимостей
```bash
sudo pacman -S i3lock scrot   # Основные компоненты
yay -S ttf-fira-code         # Шрифт Fira Code
```

### 2. Создание фонового изображения
```bash
mkdir -p ~/Images/system/
# Используйте любое изображение 1920x1080
convert -size 1920x1080 xc:black ~/Images/system/lock_screen.png
```

### 3. Разрешения для скрипта
```bash
chmod +x screen-lock
mv screen-lock ~/.local/bin/
```

---

## Пример использования
1. Блокировка по горячим клавишам в i3wm:
```bash
# ~/.config/i3/config
bindsym $mod+l exec --no-startup-id screen-lock
```

2. Ручной запуск:
```bash
screen-lock
```

---

## Возможные проблемы и решения

### 1. Изображение не найдено
- Проверьте путь к файлу
- Убедитесь в наличии прав на чтение

### 2. Шрифты не отображаются
```bash
fc-match "Fira Code"  # Проверка установки шрифта
sudo pacman -S noto-fonts # Альтернативный шрифт
```

### 3. Неправильное позиционирование
- Отрегулируйте координаты под ваше разрешение:
```bash
# Для экрана 2560x1440:
--time-pos="1280:720" \
--date-pos="1280:800" \
```

### 4. Высокая нагрузка ЦП
```bash
--refresh-rate=30  # Ограничить частоту обновления
```

---

## Дополнительные модификации

### 1. Размытие фона
```bash
# Требуется scrot и imagemagick
lock_image="/tmp/lock.png"
scrot "$lock_image"
convert "$lock_image" -blur 0x8 "$lock_image"
```

### 2. Анимация индикатора
```bash
--radius 120 \          # Больший радиус
--ring-width 15 \       # Тонкое кольцо
--ind-pos="w/2:h/2+60" # Центровка по ширине
```

### 3. Пользовательские сообщения
```bash
--greeter-text="Добро пожаловать, $USER!" \
--wrong-text="Неверно! Попробуйте снова" \
```

Скрипт предлагает расширенные возможности кастомизации экрана блокировки, идеально подходит для пользователей, желающих создать уникальный визуальный стиль системы.