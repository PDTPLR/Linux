## Исходный код
```bash
#!/bin/bash

# ==================== НАСТРОЙКИ ====================
export BORG_REPO="/home/pdtplr/backups/borg-repo"      # Путь к репозиторию Borg
export BORG_PASSPHRASE="your_strong_password_here"     # Шифрование репозитория
EXCLUDE_FROM="/home/pdtplr/.borg-exclude"              # Файл исключений
LOG_FILE="/home/pdtplr/backups/borg-backup.log"        # Файл лога
LOCK_FILE="/tmp/borg_backup.lock"                      # Файл блокировки
MAX_ATTEMPTS=3                                         # Макс. попыток
ATTEMPT_DELAY=300                                      # Задержка между попытками (5 мин)
RETENTION_POLICY="--keep-daily 7 --keep-weekly 4 --keep-monthly 6" # Политика хранения

# ==================== ИНИЦИАЛИЗАЦИЯ ====================
mkdir -p "$(dirname "$BORG_REPO")" "$(dirname "$LOG_FILE")"
touch "$LOG_FILE" "$EXCLUDE_FROM"

# ==================== ФУНКЦИИ ====================
notify() {
    export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus
    local urgency=$1
    local message=$2
    notify-send -u "$urgency" -t 10000 "Borg Backup" "$message"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

acquire_lock() {
    exec 9>"$LOCK_FILE"
    flock -n 9 || return 1
}

check_dependencies() {
    for cmd in borg notify-send; do
        if ! command -v $cmd &>/dev/null; then
            notify "critical" "Ошибка: Не установлен $cmd"
            exit 1
        fi
    done
}

init_repo() {
    if [ ! -d "$BORG_REPO" ]; then
        if ! borg init --encryption=repokey-blake2 "$BORG_REPO" >> "$LOG_FILE" 2>&1; then
            notify "critical" "Ошибка инициализации репозитория"
            exit 2
        fi
    fi
}

# ==================== ОСНОВНАЯ ЛОГИКА ====================
main() {
    check_dependencies
    init_repo

    for ((i=1; i<=MAX_ATTEMPTS; i++)); do
        if acquire_lock; then
            borg break-lock "$BORG_REPO" >> "$LOG_FILE" 2>&1
            backup_name="eva-$(date +%Y-%m-%d_%H-%M-%S)"
            
            notify "normal" "🔄 Попытка $i/$MAX_ATTEMPTS: Создание бэкапа..."
            
            # Создание бэкапа
            if borg create --stats \
                --compression zstd \
                --exclude-from "$EXCLUDE_FROM" \
                "$BORG_REPO::$backup_name" \
                /home/pdtplr \
                >> "$LOG_FILE" 2>&1
            then
                # Проверка целостности
                if borg check "$BORG_REPO" >> "$LOG_FILE" 2>&1; then
                    notify "normal" "✅ Бэкап $backup_name успешно создан и проверен!"
                    
                    # Очистка старых бэкапов
                    if borg prune --stats $RETENTION_POLICY "$BORG_REPO" >> "$LOG_FILE" 2>&1; then
                        notify "normal" "🧹 Старые бэкапы очищены"
                    else
                        notify "critical" "⚠️ Ошибка очистки бэкапов!"
                    fi
                    
                    rm -f "$LOCK_FILE"
                    exit 0
                else
                    notify "critical" "⚠️ Ошибка проверки бэкапа!"
                fi
            else
                notify "critical" "❌ Ошибка создания бэкапа! Повтор через ${ATTEMPT_DELAY} сек..."
                sleep $ATTEMPT_DELAY
            fi
        else
            notify "low" "⏳ Процесс уже выполняется. Ожидание..."
            sleep 60
        fi
    done
    
    notify "critical" "🔥 Все попытки создания бэкапа провалились!"
    exit 1
}

# ==================== ЗАПУСК ====================
main "$@"
```

---

### 🔍 Подробное описание скрипта:

#### 1. Улучшенная безопасность
- **Шифрование репозитория**: Используется `repokey-blake2` для защиты данных
- **Проверка зависимостей**: Гарантирует наличие всех необходимых утилит
- **Инициализация репозитория**: Автоматическое создание при первом запуске

#### 2. Расширенное управление бэкапами
- **Политика хранения**: 
  - Ежедневные бэкапы за 7 дней
  - Еженедельные за 4 недели
  - Ежемесячные за 6 месяцев
- **Сжатие zstd**: Оптимальное соотношение скорость/степень сжатия
- **Проверка целостности**: После создания выполняется `borg check`

#### 3. Улучшенные уведомления
- Разные уровни важности (normal/low/critical)
- Подробное логирование всех операций
- Визуальные индикаторы статуса (эмодзи)

#### 4. Надёжность выполнения
- Межпроцессная блокировка через `flock`
- Повторные попытки при ошибках
- Автоматическая очистка блокировок Borg

#### 5. Рекомендации для Arch Linux
1. Установите зависимости:
```bash
sudo pacman -S borg python-notify2 zstd
```

2. Настройте исключения в `~/.borg-exclude`:
```
/home/*/.cache/
/home/*/.thumbnails
/var/tmp/*
```

3. Активируйте сервис:
```bash
systemctl --user enable borg-backup.timer
```

4. Просмотр бэкапов:
```bash
borg list /home/pdtplr/backups/borg-repo
```

---

### 🚀 Особенности работы:
- **Автоматическое восстановление** при сбоях
- **Подробные логи** для диагностики проблем
- **Гибкая настройка** через параметры в начале скрипта
- **Оптимизированное хранилище** за счёт сжатия и дедупликации

Скрипт обеспечивает профессиональное резервное копирование с защитой от потери данных и удобным управлением историей бэкапов.