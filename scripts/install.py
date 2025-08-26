#!/usr/bin/env python3

import os
import subprocess
import shutil
import datetime
import distro
from pathlib import Path
import inquirer

# Конфигурация
DOTFILES_DIR = Path.home() / "git/dotfiles"
PACKAGES_FILE = DOTFILES_DIR / "packages.txt"
BACKUP_DIR = Path.home() / f".config/backup-{datetime.datetime.now().strftime('%F-%H%M%S')}"

def run_command(cmd, check=True):
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if check and result.returncode != 0:
        print(f"\033[31mОшибка: {result.stderr}\033[0m")
        exit(1)
    return result

def check_root():
    if os.geteuid() == 0:
        print("\033[31mОшибка: Скрипт не должен запускаться от root.\033[0m")
        exit(1)

def detect_distro():
    return distro.id()

def install_packages(distro_id):
    if not PACKAGES_FILE.exists():
        print(f"\033[31mОшибка: Файл {PACKAGES_FILE} не найден.\033[0m")
        exit(1)
    with open(PACKAGES_FILE, "r") as f:
        packages = f.read().strip().splitlines()

    print(f"\033[33mОбнаружен дистрибутив: {distro_id}\033[0m")
    if distro_id == "arch":
        run_command(f"sudo pacman -S --needed {' '.join(packages)}")
    elif distro_id in ["ubuntu", "debian"]:
        print("\033[33mПредупреждение: Некоторые пакеты могут отсутствовать в Ubuntu/Debian.\033[0m")
        run_command("sudo apt update")
        filtered_packages = [p for p in packages if p not in ["yay", "linux-", "-nerd", "base", "base-devel", "grub", "intel-ucode", "linux-firmware"]]
        run_command(f"sudo apt install -y {' '.join(filtered_packages)}", check=False)
    else:
        print(f"\033[31mДистрибутив {distro_id} не поддерживается!\033[0m")
        print("\n".join(packages))
        exit(1)

def copy_dotfiles(components):
    print(f"\033[33mСоздание резервной копии в {BACKUP_DIR}...\033[0m")
    BACKUP_DIR.mkdir(parents=True, exist_ok=True)
    for path in [".config/bspwm", ".config/sxhkd", ".config/polybar", ".config/picom", ".config/rofi",
                 ".config/dunst", ".config/fish", ".local/bin", ".xinitrc", ".bashrc", "Images",
                 ".local/share/fonts"]:
        path = Path.home() / path
        if path.exists():
            shutil.move(path, BACKUP_DIR / path.name)

    if "configs" in components:
        print("\033[32mКопирование конфигураций...\033[0m")
        config_dir = Path.home() / ".config"
        config_dir.mkdir(exist_ok=True)
        for folder in ["bspwm", "sxhkd", "polybar", "picom", "rofi", "dunst", "fish"]:
            src = DOTFILES_DIR / "configs" / folder
            if src.exists():
                shutil.copytree(src, config_dir / folder, dirs_exist_ok=True)
        shutil.copy(DOTFILES_DIR / ".xinitrc", Path.home() / ".xinitrc")
        shutil.copy(DOTFILES_DIR / ".bashrc", Path.home() / ".bashrc")

    if "scripts" in components:
        print("\033[32mКопирование скриптов...\033[0m")
        (Path.home() / ".local/bin").mkdir(parents=True, exist_ok=True)
        for folder in ["utils", "color-scripts", "fetchs"]:
            src = DOTFILES_DIR / "scripts" / folder
            if src.exists():
                for script in src.glob("*"):
                    if script.is_file():
                        shutil.copy(script, Path.home() / ".local/bin" / script.name)
        run_command("chmod -R +x ~/.local/bin")

    if "wallpapers" in components:
        print("\033[32mКопирование обоев...\033[0m")
        (Path.home() / "Images").mkdir(exist_ok=True)
        src = DOTFILES_DIR / "assets/wallpapers"
        if src.exists():
            for wallpaper in src.glob("*"):
                shutil.copy(wallpaper, Path.home() / "Images" / wallpaper.name)

    if "fonts" in components:
        print("\033[32mКопирование шрифтов...\033[0m")
        (Path.home() / ".local/share/fonts").mkdir(parents=True, exist_ok=True)
        src = DOTFILES_DIR / "assets/fonts"
        if src.exists():
            for font in src.glob("*"):
                shutil.copy(font, Path.home() / ".local/share/fonts" / font.name)
        run_command("fc-cache -fv")

def setup_xinitrc():
    xinitrc = Path.home() / ".xinitrc"
    if xinitrc.exists() and "exec bspwm" not in xinitrc.read_text():
        with open(xinitrc, "a") as f:
            f.write("exec bspwm\n")
        print("\033[32mДобавлен 'exec bspwm' в ~/.xinitrc\033[0m")

def setup_path():
    bashrc = Path.home() / ".bashrc"
    fish_config = Path.home() / ".config/fish/config.fish"
    fish_config.parent.mkdir(exist_ok=True)
    if bashrc.exists() and ".local/bin" not in bashrc.read_text():
        with open(bashrc, "a") as f:
            f.write('export PATH="$HOME/.local/bin:$PATH"\n')
        print("\033[32mДобавлен ~/.local/bin в PATH для Bash\033[0m")
    if fish_config.exists() and ".local/bin" not in fish_config.read_text():
        with open(fish_config, "a") as f:
            f.write('set -gx PATH $HOME/.local/bin $PATH\n')
        print("\033[32mДобавлен ~/.local/bin в PATH для Fish\033[0m")

def main():
    check_root()
    questions = [
        inquirer.Checkbox(
            "components",
            message="Выберите компоненты для установки",
            choices=[
                ("Пакеты", "packages"),
                ("Конфигурации", "configs"),
                ("Скрипты", "scripts"),
                ("Обои", "wallpapers"),
                ("Шрифты", "fonts"),
                ("Настройка .xinitrc", "xinitrc"),
                ("Настройка PATH", "path"),
            ],
            default=["packages", "configs", "scripts", "wallpapers", "fonts", "xinitrc", "path"],
        ),
    ]
    answers = inquirer.prompt(questions)
    if not answers:
        print("\033[31mУстановка отменена.\033[0m")
        exit(0)
    components = answers["components"]

    distro_id = detect_distro()
    if "packages" in components:
        install_packages(distro_id)
    if any(c in components for c in ["configs", "scripts", "wallpapers", "fonts"]):
        copy_dotfiles(components)
    if "xinitrc" in components:
        setup_xinitrc()
    if "path" in components:
        setup_path()

    print("\033[32mУстановка завершена! Выполните 'startx' для запуска BSPWM.\033[0m")
    print("Подробности в README.md и docs/installation.md.")

if __name__ == "__main__":
    main()
