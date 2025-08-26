# 🌟 PDTPLR's BSPWM Dotfiles

[![GitHub stars](https://img.shields.io/github/stars/PDTPLR/Linux?style=for-the-badge&color=brightgreen)](https://github.com/PDTPLR/Linux/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/PDTPLR/Linux?style=for-the-badge&color=blue)](https://github.com/PDTPLR/Linux/network)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)](https://github.com/PDTPLR/Linux/blob/main/LICENSE)
[![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)](https://archlinux.org/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com/)

![Dotfiles Showcase](https://github.com/PDTPLR/Linux/raw/main/screenshots/bspwm.png) <!-- Замените на реальный GIF или видео, если добавите; можно использовать внешний хостинг как Giphy для анимации -->

> **Добро пожаловать в мир идеального баланса производительности и стиля!**  
> Эти dotfiles — это не просто конфиги. Это твой персональный портал в минималистичный, быстрый и эстетичный Linux-десктоп на базе BSPWM. Оптимизировано для Arch Linux с частичной поддержкой Ubuntu/Debian. Забудь о тяжёлых DE — здесь всё лёгкое, как перышко, с использованием менее 700 МБ RAM на старте. Готов к трансформации? 🚀

## 📑 Содержание
- [Добро Пожаловать](#-добро-пожаловать)
- [Ключевые Возможности](#-ключевые-возможности)
- [Галерея](#-галерея)
- [Установка](#-установка)
- [После Установки](#-после-установки)
- [Горячие Клавиши](#-горячие-клавиши)
- [Документация](#-документация)
- [Как Помочь](#-как-помочь)
- [Кредиты и Лицензия](#-кредиты-и-лицензия)

## 👋 Добро Пожаловать
Привет! Я PDTPLR, и эти dotfiles созданы для тех, кто ценит **минимализм, скорость и красоту**. BSPWM — это сердце setups, окружённое Polybar, Picom, Alacritty, Rofi, Dunst и Fish shell. Всё настроено для повседневного использования: от кодинга до гейминга.

Это не просто репозиторий — это готовый продукт для твоего десктопа. 63 уникальных обоев, умные скрипты и кастомные хоткеи ждут тебя. Установи за минуты и почувствуй разницу! 🌌

## 🔥 Ключевые Возможности
Вот что делает эти dotfiles **особенными**:

| Фича | Описание |
|------|----------|
| **⚙️ Гибкость Конфигов** | Полностью кастомизируй BSPWM, Polybar, Rofi и больше. Всё в `configs/` — редактируй под себя! | 
| **🖼️ 63 Обоев** | Динамические фоны в `assets/wallpapers/`. Меняй на лету! | 
| **🔤 Nerd Fonts** | Идеальные иконки для терминалов и баров. | 
| **📜 Скрипты Магии** | Утилиты для системы, Wi-Fi, цветов и fetch'ей в `scripts/`. Автоматизируй всё! | 
| **⌨️ Горячие Клавиши** | Интуитивные комбинации в `configs/sxhkd/sxhkdrc`. | 
| **⚡ Низкое Потребление** | Менее 700 МБ RAM — лёгкий как воздух. | 
| **📦 Авто-Установка** | `install.sh` для быстрой установки или `install.py` для интерактива. | 
| **🖥️ Поддержка Разрешений** | Работает на разных экранах, включая 1920x1080. | 

Эти фичи не просто список — они **революционизируют твой workflow**. Представь: мгновенная смена тем, уведомления в стиле и бар, который всегда под рукой. Это не dotfiles — это **твой новый любимый десктоп**! 💎

## 🖼️ Галерея
Погрузись в визуалы. Вот как это выглядит в действии:

| Скриншот | Описание |
|----------|----------|
| ![BSPWM](https://github.com/PDTPLR/Linux/raw/main/screenshots/bspwm.png) | Основной вид BSPWM с Polybar. |
| ![BTOP](https://github.com/PDTPLR/Linux/raw/main/screenshots/btop.png) | Мониторинг системы в BTOP. |
| ![Ranger](https://github.com/PDTPLR/Linux/raw/main/screenshots/ranger.png) | Файловый менеджер Ranger в действии. |

Больше скринов в [screenshots/](https://github.com/PDTPLR/Linux/tree/main/screenshots). Добавь свой и поделись в Issues! 📸

## 📥 Установка
### Быстрая Установка (Arch Linux Рекомендуется)
1. Клонируй репо: `git clone https://github.com/PDTPLR/Linux.git ~/.dotfiles`
2. Перейди в директорию: `cd ~/.dotfiles`
3. Запусти: `./scripts/install.sh`

### Интерактивная Установка
- `./scripts/install.py` — выбери опции шаг за шагом.

Для Ubuntu/Debian: Следуй [docs/installation.md](https://github.com/PDTPLR/Linux/blob/main/docs/installation.md) для адаптации.

**Важно:** Убедись, что у тебя установлен `git`, `python3` и базовые зависимости. Полный гайд в [docs/installation.md](https://github.com/PDTPLR/Linux/blob/main/docs/installation.md).

## 🛠️ После Установки
Возникли вопросы? Вот быстрые фиксы:
- **Батарея в Polybar:** Настрой в `configs/polybar/config.ini`.
- **Анимации:** Проверь Picom в `configs/picom/picom.conf`.
- **Обои:** Скрипт в `scripts/utils/wallpaper.sh`.
- **Шрифты:** `fc-cache -fv` для обновления.

Подробности в [docs/troubleshooting.md](https://github.com/PDTPLR/Linux/blob/main/docs/troubleshooting.md) и [docs/usage.md](https://github.com/PDTPLR/Linux/blob/main/docs/usage.md).

## ⌨️ Горячие Клавиши
Управляй всем с клавиатуры! Вот топ:

- `Super + Enter`: Открыть терминал (Alacritty).
- `Super + W`: Смена обоев.
- `Super + С`: Закрыть окно.
- `Super + Space`: Поменять язык.

Полный список в [docs/hotkeys.md](https://github.com/PDTPLR/Linux/blob/main/docs/hotkeys.md) или `configs/sxhkd/sxhkdrc`.

## 📚 Документация
Всё, что нужно знать:
- [Установка](https://github.com/PDTPLR/Linux/blob/main/docs/installation.md)
- [Проблемы](https://github.com/PDTPLR/Linux/blob/main/docs/troubleshooting.md)
- [Использование](https://github.com/PDTPLR/Linux/blob/main/docs/usage.md)
- [Скрипты](https://github.com/PDTPLR/Linux/blob/main/docs/scripts.md)
- [Горячие Клавиши](https://github.com/PDTPLR/Linux/blob/main/docs/hotkeys.md)
- [Контрибьютинг](https://github.com/PDTPLR/Linux/blob/main/docs/contributing.md)

![Footer Banner](https://img.shields.io/badge/Made%20with%20❤️%20by%20PDTPLR-000000?style=for-the-badge&logo=github)
