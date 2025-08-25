
## Исходный код
```python
import os
import sys
from PIL import Image

wallpaper_path = None
monitor_size = "1920x1080"

black_list = [
    "gif", "swf", "bmp", "htt", "tif", "x",
    "htm", "ini", "txt", "mp4", "js", "html",
    "css", "ucs2le", "avi", "md", "cpyr"
]

if len(sys.argv) <= 1:
    raise SystemExit("specify the path to the wallpaper")
else:
    wallpaper_path = sys.argv[1]
    print(f"Wallpaper Path: {wallpaper_path}")
    print(f"Image Size: {monitor_size}\n")

for wallpaper in os.listdir(wallpaper_path):
    path = os.path.join(wallpaper_path, wallpaper)
    if os.path.isfile(path):
        wallpaper_extension = wallpaper.split('.')[-1].lower()

        # Удаление файлов с запрещенными расширениями
        if wallpaper_extension in black_list:
            remove_ext = os.path.join(wallpaper_path, wallpaper)
            print(f"Remove invalid extension: {wallpaper}")
            os.remove(remove_ext)
            continue

        image = Image.open(path)
        (width, height) = image.size
        wallpaper_size = f"{width}x{height}"

        if wallpaper_size != monitor_size:
            os.remove(path)
            print(f"{wallpaper} removed. size: {wallpaper_size}")
```

## Принцип работы
1. **Фильтрация по расширениям**:
   - Удаляет файлы с расширениями из черного списка
   - Поддерживаемые форматы: jpg/jpeg/png (неявно, через отсутствие в blacklist)

2. **Проверка разрешения**:
   - Удаляет изображения, не соответствующие заданному размеру
   - Использует бибилиотеку Pillow (PIL) для анализа метаданных

3. **Безопасность**:
   - Работает только с обычными файлами (не с директориями)
   - Требует явного указания пути через аргумент

## Особенности для Arch Linux
1. Установка зависимостей:
```bash
sudo pacman -S python python-pillow
```

2. Пример использования:
```bash
python wallpaper_filter.py ~/Pictures/Wallpapers
```

3. Рекомендуемые доработки:
```python
# Добавить проверку существования пути
if not os.path.isdir(wallpaper_path):
    raise SystemExit("Invalid directory path")

# Добавить обработку ошибок изображений
try:
    image = Image.open(path)
except Exception as e:
    print(f"Invalid image: {wallpaper} ({str(e)})")
    continue

# Добавить поддержку разных соотношений сторон
target_w, target_h = map(int, monitor_size.split('x'))
aspect = target_w/target_h
current_aspect = width/height
if not (0.95 < current_aspect/aspect < 1.05):
    print(f"Aspect ratio mismatch: {wallpaper}")
```

## Сильные стороны
- Автоматизирует очистку коллекции обоев
- Легко кастомизировать черный список
- Не требует графического интерфейса

## Потенциальные проблемы
- Невозможность восстановления удаленных файлов
- Отсутствие проверки качества изображения
- Не учитывает ретину/HiDPI (работает с физическими пикселями)

## Безопасное использование
1. Сначала сделайте тестовый прогон:
```python
# Заменить os.remove на:
print(f"[DRY RUN] Would delete: {wallpaper}")
```
2. Создайте бэкап:
```bash
cp -r ~/Pictures/Wallpapers ~/wallpapers_backup
```