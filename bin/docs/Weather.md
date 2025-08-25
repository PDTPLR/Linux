
## Исходный код
```bash
#!/bin/sh

city="Kiev"
url="wttr.in/$city?format=3"
weather=$(curl -s $url)

if [ $(echo "$weather" | grep -E "(Unknown|curl|HTML)" | wc -l) -gt 0 ]; then
    echo "WEATHER UNAVAILABLE"
else
    echo "$weather" | awk '{print $1" "$3}'
fi
```

## Разбор работы скрипта

### 1. Базовые настройки
```bash
#!/bin/sh
city="Kiev"
```
- Использует минималистичный shell (`/bin/sh`)
- Жёстко задан город Киев (можно менять редактированием скрипта)

### 2. Формирование URL
```bash
url="wttr.in/$city?format=3"
```
- Использует сервис `wttr.in`
- Параметр `format=3` - специальный компактный вывод:
  Пример вывода: `Kiev: ⛅ +17°C`

### 3. Получение данных
```bash
weather=$(curl -s $url)
```
- `curl -s` - тихий режим без прогресс-бара
- Сохраняет результат в переменную `weather`

### 4. Проверка ошибок
```bash
if [ $(echo "$weather" | grep -E "(Unknown|curl|HTML)" | wc -l) -gt 0 ]; then
```
- Ищет в выводе ключевые слова ошибок:
  - `Unknown` - неизвестный город
  - `curl` - проблемы с соединением
  - `HTML` - получена HTML-страница (ошибка 404/500)

### 5. Обработка вывода
```bash
echo "$weather" | awk '{print $1" "$3}'
```
- Фильтрация через `awk`:
  - `$1` - название города с двоеточием (Kiev:)
  - `$3` - температура (+17°C)
- Удаляет погодные иконки (⛅), которые находятся в $2

## Пример работы
**Входные данные:**
```
Kiev: ⛅ +17°C
```

**Результат выполнения:**
```
Kiev: +17°C
```

## Требования для Arch Linux
1. Установите зависимости:
```bash
sudo pacman -S curl
```

2. Для корректного отображения иконок:
```bash
sudo pacman -S noto-fonts-emoji  # Поддержка эмоджи
```

3. Настройте терминал:
```bash
echo 'export LANG=en_US.UTF-8' >> ~/.bashrc
source ~/.bashrc
```

## Возможные улучшения
1. Динамический выбор города:
```bash
#!/bin/sh

city="${1:-Kiev}"  # Берёт город из аргумента или Киев по умолчанию
url="wttr.in/$city?format=3"
...
```

2. Расширенная обработка ошибок:
```bash
weather=$(curl -sfG --compressed "$url") || {
    echo "CONNECTION ERROR"
    exit 1
}
```

3. Параметризация формата:
```bash
format=${2:-3}  # Второй аргумент - формат вывода
url="wttr.in/$city?format=$format"
```

4. Версия для Wayland/современных терминалов:
```bash
curl -s "wttr.in/$city?format=v2"
```

## Особенности работы
- Требует активного интернет-соединения
- Работает только с английскими названиями городов
- Чувствителен к регистру (Kiev ≠ KIEV)
- Автоматически обновляет данные при каждом запуске

Для ежедневного использования можно добавить в `.bashrc`:
```bash
alias weather='/path/to/weather_script'
```