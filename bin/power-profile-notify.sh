#!/usr/bin/env bash

PROFILE_FILE="/sys/firmware/acpi/platform_profile"
LOG_FILE="$HOME/.power_profile.log"

# Иконки (Nerd Fonts)
declare -A ICONS=(
    ["low-power"]="󰌪"
    ["balanced"]="󰓅"
    ["performance"]="󰍛"
)

# Цвета в HEX
declare -A COLORS=(
    ["low-power"]="#73daca"
    ["balanced"]="#e0af68"
    ["performance"]="#f7768e"
)

# Логирование
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Отправка уведомления
send_notification() {
    local profile="$1"
    local display_name
    case "$profile" in
        "low-power") display_name="Экономия" ;;
        "balanced") display_name="Сбалансированный" ;;
        "performance") display_name="Производительность" ;;
        *) display_name="Неизвестный" ;;
    esac

    # Проверка переменных окружения
    if [[ -z "$DISPLAY" || -z "$DBUS_SESSION_BUS_ADDRESS" ]]; then
        log "Предупреждение: DISPLAY или DBUS_SESSION_BUS_ADDRESS не установлены, пропуск уведомления"
        return 1
    fi

    # Проверка, запущен ли dunst
    if ! pgrep -u "$USER" dunst >/dev/null; then
        log "Предупреждение: dunst не запущен, пропуск уведомления"
        return 1
    fi

    # Попытка отправить уведомление
    notify-send -u normal \
        -i preferences-system-power \
        "Режим питания" \
        "<span color='${COLORS[$profile]}' font='16'>${ICONS[$profile]} $display_name</span>" 2>> "$LOG_FILE" || {
        log "Ошибка отправки уведомления для профиля: $profile"
        return 1
    }
    log "Уведомление отправлено: $display_name"
}

# Мониторинг профиля
monitor_profile() {
    log "Запуск мониторинга..."
    if [[ ! -r "$PROFILE_FILE" ]]; then
        log "Ошибка: Нет доступа к $PROFILE_FILE"
        echo "Ошибка: Нет доступа к $PROFILE_FILE" >&2
        exit 1
    fi

    # Ожидание инициализации D-Bus
    for ((i=0; i<180; i++)); do
        if [[ -n "$DBUS_SESSION_BUS_ADDRESS" && -S "${DBUS_SESSION_BUS_ADDRESS#unix:path=}" ]]; then
            log "D-Bus доступен"
            break
        fi
        log "Ожидание D-Bus ($i/180)..."
        sleep 1
    done

    # Дополнительная задержка для BSPWM
    log "Ожидание инициализации BSPWM..."
    sleep 10

    while true; do
        current_profile=$(cat "$PROFILE_FILE" 2>> "$LOG_FILE")
        case "$current_profile" in
            "low-power"|"balanced"|"performance")
                send_notification "$current_profile"
                ;;
            *)
                log "Неизвестный режим: $current_profile"
                ;;
        esac
        inotifywait -q -e modify "$PROFILE_FILE" >> "$LOG_FILE" 2>&1
    done
}

# Проверка зависимостей
check_deps() {
    for dep in inotifywait notify-send; do
        if ! command -v "$dep" >/dev/null; then
            log "Ошибка: $dep не установлен"
            echo "Ошибка: $dep не установлен" >&2
            exit 1
        fi
    done
}

check_deps
monitor_profile
