#!/usr/bin/env bash

# ╔════════════════════════════════════════════════════════════════════╗
# ║ Polybar Launch Script with Auto-Restart                           ║
# ║                                                                    ║
# ║ Этот скрипт запускает Polybar с автоматическим перезапуском       ║
# ║ через 5 секунд для решения проблем инициализации.                 ║
# ╚════════════════════════════════════════════════════════════════════╝

# ---------------------------------------
# СЕКЦИЯ 1: ИНИЦИАЛИЗАЦИЯ
# ---------------------------------------

# Путь к лог-файлу
LOG_FILE="/tmp/polybar_top.log"

# Цвета для вывода в терминал
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Очистка лога только при первом запуске
if [ ! -f "$LOG_FILE" ] || ! grep -q "АВТОМАТИЧЕСКИЙ ПЕРЕЗАПУСК" "$LOG_FILE"; then
    echo "--- [$(date)] ПЕРВОНАЧАЛЬНЫЙ ЗАПУСК POLYBAR ---" | tee "$LOG_FILE"
fi

# ---------------------------------------
# СЕКЦИЯ 2: ПРОВЕРКА ЗАВИСИМОСТЕЙ
# ---------------------------------------

# Проверка наличия Polybar
if ! command -v polybar >/dev/null 2>&1; then
    echo -e "${RED}[ОШИБКА] Polybar не установлен. Установите его: sudo pacman -S polybar${NC}" | tee -a "$LOG_FILE"
    exit 1
fi

# Проверка конфигурации
CONFIG_PATH="$HOME/.config/polybar/config.ini"
if [ ! -f "$CONFIG_PATH" ]; then
    echo -e "${RED}[ОШИБКА] Файл конфигурации $CONFIG_PATH не найден${NC}" | tee -a "$LOG_FILE"
    exit 1
fi

# ---------------------------------------
# СЕКЦИЯ 3: ОСТАНОВКА СУЩЕСТВУЮЩИХ ПРОЦЕССОВ
# ---------------------------------------

# Завершение всех запущенных экземпляров Polybar
echo -e "${BLUE}[ИНФО] Завершение существующих процессов Polybar...${NC}" | tee -a "$LOG_FILE"
killall -q polybar

# Ожидание завершения процессов
while pgrep -u "$UID" -x polybar >/dev/null; do
    sleep 0.5
done

# ---------------------------------------
# СЕКЦИЯ 4: ЗАПУСК POLYBAR
# ---------------------------------------

# Определение подключённых мониторов
MONITORS=$(xrandr --query | grep " connected" | cut -d" " -f1)

if [ -z "$MONITORS" ]; then
    echo -e "${RED}[ОШИБКА] Не найдены подключённые мониторы${NC}" | tee -a "$LOG_FILE"
    exit 1
fi

# Запуск Polybar для каждого монитора
for MONITOR in $MONITORS; do
    echo -e "${BLUE}[ИНФО] Запуск Polybar на мониторе: $MONITOR${NC}" | tee -a "$LOG_FILE"
    MONITOR="$MONITOR" polybar top -r >>"$LOG_FILE" 2>&1 &
    disown
    sleep 0.2 # Небольшая задержка для предотвращения конфликтов
done

# ---------------------------------------
# СЕКЦИЯ 5: АВТОМАТИЧЕСКИЙ ПЕРЕЗАПУСК
# ---------------------------------------

# Запуск фонового процесса для автоматического перезапуска
(
    # Ждем 5 секунд перед перезапуском
    sleep 2
    
    echo -e "${YELLOW}[ИНФО] АВТОМАТИЧЕСКИЙ ПЕРЕЗАПУСК POLYBAR ЧЕРЕЗ 5 СЕКУНД...${NC}" | tee -a "$LOG_FILE"
    
    # Снова завершаем все процессы Polybar
    killall -q polybar
    
    # Ожидаем завершения процессов
    while pgrep -u "$UID" -x polybar >/dev/null; do
        sleep 0.5
    done
    
    # Перезапускаем Polybar для каждого монитора
    for MONITOR in $MONITORS; do
        echo -e "${BLUE}[ИНФО] Перезапуск Polybar на мониторе: $MONITOR${NC}" | tee -a "$LOG_FILE"
        MONITOR="$MONITOR" polybar top -r >>"$LOG_FILE" 2>&1 &
        disown
        sleep 0.2
    done
    
    echo -e "${GREEN}[УСПЕХ] Polybar успешно перезапущен${NC}" | tee -a "$LOG_FILE"
) &

# ---------------------------------------
# СЕКЦИЯ 6: ЗАВЕРШЕНИЕ
# ---------------------------------------

echo -e "${GREEN}[УСПЕХ] Панель Polybar успешно запущена${NC}" | tee -a "$LOG_FILE"
echo -e "${YELLOW}[ИНФО] Автоматический перезапуск запланирован через 5 секунд${NC}" | tee -a "$LOG_FILE"
