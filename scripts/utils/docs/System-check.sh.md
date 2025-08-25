## Исходный код

```bash
#!/bin/bash
# Полная диагностика системы для Arch Linux

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

LOG_FILE="full_system_check_$(date +%Y%m%d_%H%M%S).log"

check_deps() {
    local deps=(
        inxi lspci lsusb dmesg journalctl glxinfo xrandr
        smartctl nmcli iptables ss pacman fwupdmgr
        lsblk df free lscpu uptime sensors dmidecode
        auditctl aide chkrootkit iotop bc
    )

    for cmd in "${deps[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            echo -e "${RED}Error: Required tool $cmd is not installed${NC}" >&2
            exit 1
        fi
    done
}

header() {
    echo -e "\n${YELLOW}=== $1 ===${NC}"
}

critical_check() {
    echo -e "${RED}[CRITICAL]${NC} $1"
}

warning_check() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

collect_info() {
    {
        # 1. Системная информация
        header "SYSTEM OVERVIEW"
        inxi -Fxxxz
        echo -e "\nUptime: $(uptime)"
        echo "Kernel: $(uname -r)"
        echo "Init System: $(ps -p 1 -o comm=)"

        # 2. Аппаратное обеспечение
        header "HARDWARE CHECKS"
        dmidecode -t system
        sensors
        sudo smartctl --scan | awk '{print $1}' | while read device; do
            echo -e "\nSMART Status for $device:"
            sudo smartctl -a "$device" 2>/dev/null | grep -E "SMART overall-health|Reallocated_Sector_Ct|Temperature_Celsius|Power_On_Hours" || true
        done

        # 3. Ядро и загрузчик
        header "KERNEL & BOOT"
        sudo grep -v '^#' /boot/loader/entries/* 2>/dev/null || true
        sudo grep -E 'root|resume' /proc/cmdline
        lsmod | grep -E 'i915|nvidia|amdgpu'
        dmesg --level=err,warn

        # 4. Графика и дисплей
        header "GRAPHICS"
        glxinfo | grep -E "OpenGL|Vendor|Renderer"
        xrandr --verbose
        journalctl -b -0 _COMM=Xorg

        # 5. Сеть
        header "NETWORK"
        nmcli device show
        ss -tulpn
        sudo iptables -L -n -v
        sudo grep -E 'error|fail' /var/log/resolvconf.log* 2>/dev/null || true

        # 6. Файловая система
        header "FILESYSTEM"
        df -hT
        lsblk -f
        sudo find / -xdev -type d -perm -0002 -uid +0 -print 2>/dev/null || true
        sudo auditctl -l

        # 7. Пользователи и безопасность
        header "USERS & SECURITY"
        sudo awk -F: '($2 == "") {print}' /etc/shadow
        sudo lastb | head -n 20
        sudo chkrootkit -q
        sudo aide --check 2>&1 || true

        # 8. Пакеты и обновления
        header "PACKAGES"
        pacman -Qkk
        checkupdates
        sudo fwupdmgr get-updates 2>&1

        # 9. Системные службы
        header "SERVICES"
        systemctl --failed
        systemctl list-units --type=service --state=running
        journalctl -p 3 -xb

        # 10. Производительность
        header "PERFORMANCE"
        free -h
        top -b -n 1 | head -n 20
        sudo iotop -oPa -n 1 -b | head -n 20

        # 11. Кастомные проверки
        header "CUSTOM CHECKS"
        VAR_USAGE=$(df /var --output=pcent | tail -1 | tr -d '% ' | awk '{print $1}')
        if [[ $VAR_USAGE =~ ^[0-9]+$ ]] && [ $VAR_USAGE -gt 90 ]; then
            warning_check "/var заполнен на ${VAR_USAGE}%"
        fi

        SWAP_TOTAL=$(free | awk '/Swap/{print $2}')
        if [ $SWAP_TOTAL -gt 0 ]; then
            SWAP_USAGE=$(free | awk '/Swap/{printf "%.0f", $3/$2*100}')
            [ $SWAP_USAGE -gt 50 ] && warning_check "Использование SWAP: ${SWAP_USAGE}%"
        fi

        CPU_TEMP=$(sensors | awk '/Package id 0/{print $4}' | tr -d '+°C' | cut -d'.' -f1)
        if [[ $CPU_TEMP =~ ^[0-9]+$ ]] && [ $CPU_TEMP -gt 85 ]; then
            critical_check "Температура CPU: ${CPU_TEMP}°C"
        fi

    } | tee "$LOG_FILE"
}

check_deps
collect_info

echo -e "\n${GREEN}Диагностика завершена. Полный отчет:${NC} $LOG_FILE"
echo -e "Для анализа ошибок выполните: grep -E 'CRITICAL|WARNING|ERROR|FAIL' $LOG_FILE"
```

---

## Подробное объяснение работы скрипта

### 1. Общее назначение
Скрипт выполняет комплексную проверку всех ключевых компонентов системы Arch Linux, включая:
- Аппаратное обеспечение
- Состояние ядра и загрузчика
- Графическую подсистему
- Сетевые настройки
- Файловые системы
- Безопасность
- Состояние пакетов
- Работоспособность служб
- Показатели производительности

### 2. Основные особенности
- **Автоматический сбор логов** в файл с временной меткой
- **Цветовое выделение** критических и предупреждающих сообщений
- **Проверка зависимостей** перед выполнением
- **Иерархическая структура** вывода
- **Кастомные проверки** для специфических сценариев

---

## Детальный разбор компонентов

### 1. Инициализация и настройки
```bash
# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

LOG_FILE="full_system_check_$(date +%Y%m%d_%H%M%S).log"
```
- **Цветовые коды** для визуального выделения
- **Генерация уникального имени лог-файла** с датой и временем

### 2. Проверка зависимостей
```bash
check_deps() {
    local deps=(...)
    for cmd in "${deps[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then ... 
    done
}
```
**Проверяет наличие критически важных утилит:**
- `inxi` - сбор системной информации
- `smartctl` - проверка здоровья дисков
- `dmidecode` - информация о железе
- `aide`/`chkrootkit` - инструменты безопасности

**Для Arch Linux требуется установка:**
```bash
sudo pacman -S inxi smartmontools dmidecode aide chkrootkit
yay -S audit iptables # Для AUR-пакетов
```

### 3. Сбор информации
#### 3.1 Системный обзор
```bash
inxi -Fxxxz
uptime
uname -r
```
- **inxi** дает полный срез системы
- **uptime** - время работы и нагрузка
- **версия ядра**

#### 3.2 Аппаратная проверка
```bash
dmidecode -t system
sensors
smartctl --scan
```
- **DMI информация** о производителе
- **Температуры** с датчиков
- **SMART-статус** дисков

#### 3.3 Графическая подсистема
```bash
glxinfo | grep -E "OpenGL|Vendor|Renderer"
xrandr --verbose
```
- **Информация о GPU**
- **Настройки дисплея**

#### 3.4 Сетевая диагностика
```bash
nmcli device show
ss -tulpn
iptables -L -n -v
```
- **Конфигурация NetworkManager**
- **Открытые порты**
- **Правила фаервола**

#### 3.5 Безопасность
```bash
sudo awk -F: '($2 == "") {print}' /etc/shadow
sudo chkrootkit -q
sudo aide --check
```
- **Поиск пустых паролей**
- **Проверка на руткиты**
- **Целостность файлов**

---

## Особенности для Arch Linux

### 1. Проверка пакетов
```bash
pacman -Qkk
checkupdates
fwupdmgr get-updates
```
- **Целостность установленных пакетов**
- **Доступные обновления**
- **Обновления прошивок**

### 2. Работа с systemd
```bash
systemctl --failed
journalctl -p 3 -xb
```
- **Неудавшиеся службы**
- **Фильтрация журналов по ошибкам**

### 3. Кастомные проверки
```bash
# Переполнение /var
VAR_USAGE=$(df /var --output=pcent | tail -n1)

# Использование SWAP
SWAP_USAGE=$(free | awk '/Swap/{printf "%.0f", $3/$2*100}')

# Температура CPU
CPU_TEMP=$(sensors | awk '/Package id 0/{print $4}')
```
**Специфичные для Arch Linux проблемы:**
- Переполнение /var при использовании pacman
- Высокая нагрузка при компиляции AUR-пакетов
- Проблемы с драйверами для нового железа

---

## Рекомендации по использованию

### 1. Установка недостающих компонентов
```bash
sudo pacman -S --needed inxi lm_sensors smartmontools dmidecode \
    mesa-demos xorg-xrandr networkmanager iptables aide chkrootkit \
    audit iotop bc
```

### 2. Запуск
```bash
chmod +x system-check.sh
sudo ./system-check.sh
```

### 3. Анализ результатов
```bash
# Поиск критических проблем
grep -E 'CRITICAL|WARNING' full_system_check_*.log

# Просмотр аппаратных данных
sed -n '/HARDWARE CHECKS/,/KERNEL & BOOT/p' *.log

# Проверка обновлений
grep -A10 "PACKAGES" *.log
```

---

## Пример вывода критических проблем

```
[CRITICAL] Температура CPU: 92°C
[WARNING] /var заполнен на 95%
[WARNING] Использование SWAP: 67%
```

---

## Безопасность и ограничения

1. **Требует root-прав** для доступа к:
   - SMART-данным дисков
   - Системным журналам
   - Настройкам безопасности

2. **Не выполняет автоматических исправлений** - только диагностика

3. **Конфиденциальные данные** (пароли, аппаратные ID) сохраняются в логах

--- 

## Дополнительные возможности

### Интеграция с мониторингом
```bash
# Добавить в cron для регулярных проверок
0 3 * * * /path/to/system-check.sh
```

### Отправка отчетов по email
```bash
mail -s "System Check Report" admin@example.com < $LOG_FILE
```

### Графическое представление
```bash
# Конвертация в HTML
aha -f $LOG_FILE > report.html
```

Этот скрипт представляет собой мощный инструмент для комплексного аудита системы Arch Linux, особенно полезный:
- После критических обновлений
- При появлении нестабильности в работе
- Для подготовки системы к резервному копированию
- При переносе конфигурации на новое железо