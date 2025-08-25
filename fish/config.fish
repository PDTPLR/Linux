
# Create aliases
alias cls="clear"
alias g="git"
alias n="nvim"
alias m="micro"

# TODO: Replace journal aliases after switching to OpenRC

# Display critical errors
alias syslog_emerg="sudo dmesg --level=emerg,alert,crit"

# Output common errors
alias syslog="sudo dmesg --level=err,warn"

# Print logs from x server
alias xlog='grep "(EE)\|(WW)\|error\|failed" ~/.local/share/xorg/Xorg.0.log'

# Remove archived journal files until the disk space they use falls below 100M
alias vacuum="journalctl --vacuum-size=100M"

# Make all journal files contain no data older than 2 weeks
alias vacuum_time="journalctl --vacuum-time=2weeks"

set -U fish_greeting
set fish_color_command green
set -gx EDITOR micro
set -gx VISUAL micro
set -gx BROWSER /usr/bin/firefox


if status is-interactive
    # Commands to run in interactive sessions can go here
end
function fish_prompt
    set -l git_branch (git branch 2>/dev/null | grep '*' | sed 's/* /🌿 /')
    set -l user_host (set_color green)"$USER@$hostname:"
    set -l current_dir (set_color blue)(prompt_pwd)
    set -l prompt_symbol (set_color normal)"\$ "
    echo -e "$user_host$current_dir$git_branch$prompt_symbol"
end

echo ""
echo -e "              Howdy, \033[35m"(whoami)"\033[37m!"
echo "   /ᐠ-˕-マ  ノ"
echo "乀(  J し)"
echo ""
