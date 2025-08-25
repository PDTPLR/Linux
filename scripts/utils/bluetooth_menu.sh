#!/usr/bin/env bash

# Логирование
LOG_FILE="/tmp/bluetooth_menu.log"
CACHE_FILE="/tmp/bluetooth_devices.cache"
log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }

# Проверка зависимостей
check_deps() {
    local missing=()
    for dep in bluetoothctl rofi notify-send rfkill; do
        command -v "$dep" &>/dev/null || missing+=("$dep")
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
        log "Error: Missing dependencies: ${missing[*]}"
        notify-send "Bluetooth" "Ошибка: не установлены: ${missing[*]}" -u critical
        exit 1
    fi
}

# Проверка и запуск сервиса
start_service() {
    if ! systemctl is-active --quiet bluetooth; then
        log "Starting bluetooth service"
        if sudo systemctl start bluetooth; then
            log "Service started"
            sleep 0.1
        else
            log "Error: Failed to start bluetooth service"
            notify-send "Bluetooth" "Ошибка запуска сервиса" -u critical
            exit 1
        fi
    fi
}

# Проверка контроллера
check_controller() {
    if ! bluetoothctl list | grep -q "Controller"; then
        log "No default controller, attempting to unblock"
        sudo rfkill unblock bluetooth
        sleep 0.1
        if ! bluetoothctl list | grep -q "Controller"; then
            log "Error: No default controller available"
            notify-send "Bluetooth" "Контроллер Bluetooth недоступен" -u critical
            exit 1
        fi
    fi
}

# Получение статуса Bluetooth
get_status() {
    if ! systemctl is-active --quiet bluetooth; then
        echo "disabled"
        return
    fi
    local powered
    powered=$(bluetoothctl show | grep -m1 "Powered" | cut -d' ' -f2)
    if [[ "$powered" == "no" ]]; then
        echo "off"
    elif bluetoothctl info | grep -q "Connected: yes"; then
        echo "connected"
    else
        echo "on"
    fi
}

# Отображение иконки
display_icon() {
    case "$(get_status)" in
        "disabled"|"off") echo "%{F#FF5555}%{F-}" ;;
        "connected") echo "≡" ;;
        "on") echo "" ;;
    esac
}

# Обновление Polybar
update_polybar() {
    polybar-msg hook bluetooth 1 &>/dev/null || log "Polybar IPC failed"
}

# Получение списка устройств с фильтрацией
get_device_list() {
    local device_list raw_list connected_macs
    # Проверяем кэш (не старше 30 секунд)
    if [[ -f "$CACHE_FILE" && $(( $(date +%s) - $(stat -c %Y "$CACHE_FILE") )) -lt 30 ]]; then
        device_list=$(cat "$CACHE_FILE")
        log "Using cached device list"
    else
        # Запускаем сканирование в фоне
        bluetoothctl --timeout 2 scan on &>/dev/null &
        local scan_pid=$!
        sleep 0.5
        raw_list=$(bluetoothctl devices | grep Device)
        kill "$scan_pid" &>/dev/null

        # Получаем список подключённых устройств
        connected_macs=$(bluetoothctl info | grep -B 1 "Connected: yes" | grep "Device" | cut -d' ' -f2)

        # Фильтруем устройства с читаемыми именами
        device_list=""
        while IFS= read -r line; do
            local mac name
            mac=$(echo "$line" | cut -d' ' -f2)
            name=$(echo "$line" | cut -d' ' -f3-)
            # Пропускаем имена, состоящие только из букв, цифр, двоеточий или дефисов
            if [[ ! "$name" =~ ^[0-9A-Fa-f:-]+$ && ! "$name" =~ ^NXP[0-9]+:[0-9]+$ && ! "$name" =~ ^SYNA[0-9]+:[0-9]+$ ]]; then
                if echo "$connected_macs" | grep -q "$mac"; then
                    device_list="$device_list ⚡ $name (Подключено)\n"
                else
                    device_list="$device_list $name\n"
                fi
            fi
        done <<< "$raw_list"

        if [[ -z "$device_list" ]]; then
            device_list="⌬ Нет устройств"
        fi
        echo -e "$device_list" > "$CACHE_FILE"
        log "Updated device cache: $device_list"
    fi
    echo -e "$device_list"
}

# Сканирование устройств
scan_devices() {
    log "Starting manual scan"
    notify-send "Bluetooth" "Сканирование устройств..." -t 1000
    bluetoothctl --timeout 5 scan on &>/dev/null
    rm -f "$CACHE_FILE"
    log "Manual scan completed"
    notify-send "Bluetooth" "Сканирование завершено" -t 1000
    update_polybar
}

# Сброс контроллера
reset_controller() {
    log "Resetting Bluetooth controller"
    notify-send "Bluetooth" "Сброс контроллера..." -t 1000
    sudo rfkill block bluetooth
    sleep 0.2
    sudo rfkill unblock bluetooth
    sleep 0.2
    if bluetoothctl list | grep -q "Controller"; then
        log "Controller reset successful"
        notify-send "Bluetooth" "Контроллер сброшен" -t 1000
    else
        log "Error: Controller reset failed"
        notify-send "Bluetooth" "Ошибка сброса контроллера" -u critical
        exit 1
    fi
    rm -f "$CACHE_FILE"
    update_polybar
}

# Показать все устройства (для отладки)
show_all_devices() {
    log "Showing all devices (including technical)"
    notify-send "Bluetooth" "Отображение всех устройств..." -t 1000
    local raw_list device_list connected_macs
    # Запускаем сканирование для актуальности
    bluetoothctl --timeout 2 scan on &>/dev/null &
    local scan_pid=$!
    sleep 0.5
    raw_list=$(bluetoothctl devices | grep Device)
    kill "$scan_pid" &>/dev/null

    # Получаем список подключённых устройств
    connected_macs=$(bluetoothctl info | grep -B 1 "Connected: yes" | grep "Device" | cut -d' ' -f2)

    # Формируем список с MAC-адресами и именами
    device_list=""
    while IFS= read -r line; do
        local mac name
        mac=$(echo "$line" | cut -d' ' -f2)
        name=$(echo "$line" | cut -d' ' -f3-)
        if echo "$connected_macs" | grep -q "$mac"; then
            device_list="$device_list ⚡ $mac: $name (Подключено)\n"
        else
            device_list="$device_list $mac: $name\n"
        fi
    done <<< "$raw_list"

    if [[ -z "$device_list" ]]; then
        log "No devices found in show_all_devices"
        echo "⌬ Нет устройств"
    else
        log "All devices: $device_list"
        echo -e "$device_list"
    fi
}

# Меню Bluetooth
show_menu() {
    log "Opening rofi menu"
    notify-send "Bluetooth" "Открытие меню..." -t 1000

    start_service
    check_controller

    local powered
    powered=$(bluetoothctl show | grep -m1 "Powered" | cut -d' ' -f2)
    if [[ "$powered" == "no" ]]; then
        bluetoothctl power on
        log "Power on"
        powered="yes"
    fi

    local device_list
    device_list=$(get_device_list)
    local toggle scan refresh reset all_devices
    if [[ "$powered" == "yes" ]]; then
        toggle="⏻ Выключить Bluetooth"
    else
        toggle="⏻ Включить Bluetooth"
    fi
    scan="⌬ Сканировать устройства"
    refresh="↻ Обновить список"
    reset="⚙ Сброс контроллера"
    all_devices="☰ Показать все устройства"

    local chosen
    chosen=$(echo -e "$toggle\n$scan\n$refresh\n$reset\n$all_devices\n$device_list" | rofi -dmenu -i -selected-row 1 -p "Bluetooth: " -width 30 -lines 12 -format s)
    log "Chosen option: $chosen"

    if [[ -z "$chosen" ]]; then
        log "No option chosen"
        exit 0
    elif [[ "$chosen" == "⏻ Включить Bluetooth" ]]; then
        bluetoothctl power on
        notify-send "Bluetooth" "Bluetooth включен" -i bluetooth -t 1000
        update_polybar
    elif [[ "$chosen" == "⏻ Выключить Bluetooth" ]]; then
        bluetoothctl power off
        notify-send "Bluetooth" "Bluetooth выключен" -i bluetooth -t 1000
        update_polybar
    elif [[ "$chosen" == "⌬ Сканировать устройства" ]]; then
        scan_devices
        show_menu
    elif [[ "$chosen" == "↻ Обновить список" ]]; then
        rm -f "$CACHE_FILE"
        show_menu
    elif [[ "$chosen" == "⚙ Сброс контроллера" ]]; then
        reset_controller
        show_menu
    elif [[ "$chosen" == "☰ Показать все устройства" ]]; then
        log "Selected show all devices"
        local all_list
        all_list=$(show_all_devices)
        if [[ "$all_list" == "⌬ Нет устройств" ]]; then
            log "No devices available in show_all_devices"
            notify-send "Bluetooth" "Нет устройств для отображения" -i bluetooth -t 2000
            exit 0
        fi
        chosen=$(echo -e "$all_list" | rofi -dmenu -i -p "Все устройства: " -width 30 -lines 12 -format s)
        log "Chosen from all devices: $chosen"
        if [[ -z "$chosen" || "$chosen" == "⌬ Нет устройств" ]]; then
            log "No device chosen from all devices"
            notify-send "Bluetooth" "Устройство не выбрано" -i bluetooth -t 2000
            exit 0
        fi
        # Обработка выбора устройства
        local chosen_name chosen_mac
        chosen_mac=$(echo "$chosen" | sed 's/^ \(⚡ \)*\([^:]*\):.*$/\2/')
        chosen_name=$(echo "$chosen" | sed 's/^ \(⚡ \)*[^:]*: \(.*\) \(.*\)/\2/')
        if [[ -z "$chosen_mac" ]]; then
            log "Error: Invalid device selection: $chosen"
            notify-send "Bluetooth" "Неверный выбор устройства" -i bluetooth -t 2000
            exit 1
        fi
        log "Selected device: $chosen_name, MAC: $chosen_mac"
        if echo "$chosen" | grep -q "(Подключено)"; then
            if bluetoothctl disconnect "$chosen_mac"; then
                notify-send "Bluetooth" "Отключено от $chosen_name" -i bluetooth -t 2000
                rm -f "$CACHE_FILE"
                update_polybar
            else
                log "Error: Failed to disconnect $chosen_name"
                notify-send "Bluetooth" "Ошибка отключения" -i bluetooth -t 2000
            fi
        else
            if bluetoothctl info "$chosen_mac" | grep -q "Paired: yes"; then
                if bluetoothctl connect "$chosen_mac"; then
                    notify-send "Bluetooth" "Подключено к $chosen_name" -i bluetooth -t 2000
                    rm -f "$CACHE_FILE"
                    update_polybar
                else
                    log "Error: Failed to connect $chosen_name"
                    notify-send "Bluetooth" "Ошибка подключения" -i bluetooth -t 2000
                fi
            else
                if bluetoothctl pair "$chosen_mac" && bluetoothctl connect "$chosen_mac"; then
                    notify-send "Bluetooth" "Подключено к $chosen_name" -i bluetooth -t 2000
                    rm -f "$CACHE_FILE"
                    update_polybar
                else
                    log "Error: Failed to pair/connect $chosen_name"
                    notify-send "Bluetooth" "Ошибка сопряжения/подключения" -i bluetooth -t 2000
                fi
            fi
        fi
    elif [[ "$chosen" == "⌬ Нет устройств" ]]; then
        log "No devices available selected"
        notify-send "Bluetooth" "Нет доступных устройств" -i bluetooth -t 2000
        exit 0
    else
        local chosen_name chosen_mac
        chosen_name=$(echo "$chosen" | sed 's/^ \(⚡ \)*//; s/ (Подключено)$//')
        chosen_mac=$(bluetoothctl devices | grep -F "$chosen_name" | cut -d' ' -f2)
        log "Selected device: $chosen_name, MAC: $chosen_mac"

        if [[ -z "$chosen_mac" ]]; then
            log "Error: Device not found"
            notify-send "Bluetooth" "Устройство не найдено" -i bluetooth -t 2000
            exit 1
        fi

        if bluetoothctl info "$chosen_mac" | grep -q "Connected: yes"; then
            if bluetoothctl disconnect "$chosen_mac"; then
                notify-send "Bluetooth" "Отключено от $chosen_name" -i bluetooth -t 2000
                rm -f "$CACHE_FILE"
                update_polybar
            else
                log "Error: Failed to disconnect $chosen_name"
                notify-send "Bluetooth" "Ошибка отключения" -i bluetooth -t 2000
            fi
        else
            if bluetoothctl info "$chosen_mac" | grep -q "Paired: yes"; then
                if bluetoothctl connect "$chosen_mac"; then
                    notify-send "Bluetooth" "Подключено к $chosen_name" -i bluetooth -t 2000
                    rm -f "$CACHE_FILE"
                    update_polybar
                else
                    log "Error: Failed to connect $chosen_name"
                    notify-send "Bluetooth" "Ошибка подключения" -i bluetooth -t 2000
                fi
            else
                if bluetoothctl pair "$chosen_mac" && bluetoothctl connect "$chosen_mac"; then
                    notify-send "Bluetooth" "Подключено к $chosen_name" -i bluetooth -t 2000
                    rm -f "$CACHE_FILE"
                    update_polybar
                else
                    log "Error: Failed to pair/connect $chosen_name"
                    notify-send "Bluetooth" "Ошибка сопряжения/подключения" -i bluetooth -t 2000
                fi
            fi
        fi
    fi
}

# Основная логика
check_deps
if [[ "$1" == "menu" ]]; then
    show_menu
else
    display_icon
fi
