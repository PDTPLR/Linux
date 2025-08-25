
## Исходный код
```bash
#!/bin/sh

# Значения по умолчанию
TEXT="${1:-abcd efg hijk lmno pqrs tuv wxyz\nABCD EFG HIJK LMNO PQRS TUV WXYZ\n  1234567890       ,./\\;'[]-=\`\n  !@#\$%%^&*()      <>?|:\"\{\}_+~}"
STYLES="${2:-normal bold italic}"

# Формирование вывода
for style in $STYLES; do
    case "$style" in
        'normal') print="$print${print:+\n}\033[0m$TEXT\033[0m" ;;
        'bold')   print="$print${print:+\n}\033[1m$TEXT\033[0m" ;;
        'italic') print="$print${print:+\n}\033[3m$TEXT\033[0m" ;;
    esac
done

echo -e "\n$print\n"

exit 0
```

## Как работает скрипт

### 1. Параметры по умолчанию
- `TEXT`: Тестовый текст с:
  - Строчными и заглавными буквами
  - Цифрами
  - Спецсимволами
  - Переносами строк (`\n`)
- `STYLES`: Список стилей через пробел

### 2. ANSI Escape-коды
- `\033[0m` - Сброс стилей
- `\033[1m` - Жирный текст
- `\033[3m` - Курсив

### 3. Логика работы
1. Принимает два аргумента:
   - Произвольный текст
   - Список стилей
2. Формирует строку с применением стилей
3. Выводит результат с переносами строк

## Примеры использования
```bash
# Базовый вариант
./testfonts

# Свой текст
./testfonts "Hello World" "bold italic"

# Многострочный текст
./testfonts "Line1\nLine2\nLine3" "normal"
```

## Особенности для Arch Linux
1. **Зависимости**:
   ```bash
   sudo pacman -S terminus-font ttf-dejavu ttf-nerd-fonts-symbols
   ```

2. **Проверка поддержки стилей**:
   ```bash
   # Жирный
   echo -e "\033[1mBold Text\033[0m"
   
   # Курсив
   echo -e "\033[3mItalic Text\033[0m"
   ```

3. **Настройка терминала**:
   - Для Alacritty добавьте в `~/.config/alacritty/alacritty.yml`:
     ```yaml
     font:
       normal:
         family: "Fira Code"
         style: "Regular"
       bold:
         style: "Bold"
       italic:
         style: "Italic"
     ```

## Возможные проблемы и решения
1. **Не отображаются стили**:
   - Установите патченные шрифты:
     ```bash
     yay -S ttf-nerd-fonts-symbols-2048-em
     ```
   - В терминале выберите шрифт с поддержкой стилей

2. **Некорректные символы**:
   ```bash
   # Установите локаль
   echo "en_US.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen
   sudo locale-gen
   ```

3. **Ошибки переносов**:
   Используйте двойные кавычки:
   ```bash
   ./testfonts "Многострочный\nтекст" "bold"
   ```

## Дополнительные модификации
### 1. Добавление цветов
```bash
case "$style" in
    'red') print="$print\033[31m$TEXT\033[0m" ;;
    'green') print="$print\033[32m$TEXT\033[0m" ;;
esac
```

### 2. Поддержка всех стилей
```bash
STYLES="${2:-normal bold italic underline blink inverse}"
```

### 3. Версия с интерактивным выбором
```bash
#!/bin/bash
echo "Выберите стиль:"
select style in normal bold italic quit; do
    case $style in
        normal|bold|italic) ./testfonts "" "$style" ;;
        quit) exit ;;
        *) echo "Некорректный вариант" ;;
    esac
done
```

Скрипт полезен для:
- Тестирования новых шрифтов
- Проверки поддержки терминалом стилей
- Демонстрации возможностей оформления текста
- Отладки цветовых схем