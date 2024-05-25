# stdout=0
# stdin=1
# stderr=2

alias ls="eza --color=always"
alias la="eza -a"
alias lt="eza -lgHMm --header --total-size --git"
alias llt="eza -lagHMm --header --total-size --git"
alias l="eza -lgHMm --header --git"
alias ll="eza -lagHMm --header --git"

alias clip="xclip -selection clipboard"
alias ff="fastfetch"
alias sl="sl -10 -cdwa"
alias simonsays="/usr/bin/sudo "
alias sudo="/usr/bin/sudo "
# alias e="emacsclient -cun"
alias q="exit"
alias c="clear"
# alias cat="bat --paging=never"

# Check updates and noitfy if an update will be required
# From https://forum.manjaro.org/t/root-tip-utility-script-check-if-updates-may-require-system-restart/14112
cu() {
    reboot="(ucode|cryptsetup|linux|nvidia|mesa|systemd|wayland|xf86-video|xorg)"
    updates=$(checkupdates)
    if [[ -z $updates ]]; then	# No updates
	return;
    fi
    echo "$updates"
    if [[ $updates =~ $reboot ]]; then
	echo "Updating possibly requires system restart ..."
    fi
}

e() {
    if [[ $# -gt 0 ]]; then
	emacsclient -cun $@
    else
	emacsclient -cun .
    fi
}

# Open man page in emacsclient frame
eman() {
    if [[ $# -eq 1 ]]; then # Single arg
	emacsclient -u -e "(man \"$1\")";
    elif [[ $# -eq 2 ]]; then # double arg
	emacsclient -u -e "(man \"$2\($1)\")";
    fi
}

# Better which
# If it is a shell built-in or function, it uses `type`
# Else (executable) is uses `file` and `whatis`
# TODO: could be both built-in and script
# $ type -a pwd
# pwd is a shell builtin
# pwd is /usr/bin/pwd
# pwd is /bin/pwd
which() {
    if [[ $# -ne 1 ]]; then
	return 1;
    fi

    # Fun little edge-case
    if [[ $1 = "which" ]]; then
	type which;
	return 0;
    fi

    # Use `which` first, then type to find out what $1 is
    path=$(/usr/bin/which $1 2>/dev/null)
    if [[ $? -ne 0 ]]; then
	type=$(type $1 2>/dev/null);
	if [[ $? -ne 0 ]]; then
	    echo "bash: $1 not found";
	    return 1;
	else
	    echo "$type";
	    whatis=$(whatis $1 2>/dev/null | grep -e '\(n\)');
	    if [[ $? -eq 0 ]]; then
		echo "$whatis";
	    fi
	fi
    else
	# If $1 is an executable, use `file` to get info about it
	file $(realpath $path);
	# If a manpage for it exists, print its description
	whatis=$(whatis $1 2>/dev/null | grep -e '\(1\)' -e '\(6\)' -e '\(8\)')
	if [[ $? -eq 0 ]]; then
	    echo "$whatis";
	fi
    fi
}

up() {
    echo $?
    if [[ $? -eq 0 ]]; then
	builtin cd ..;
	echo Entering "$PWD";
	return;
    fi

    N=$(seq $1 2>/dev/null);
    if [[ $? -ne 0 ]]; then
	echo "\"$1\" is not a valid number";
	return 1;
    fi
    for i in $N; do
	builtin cd ..;
    done
    echo Entering "$PWD";
}

ups() {
    up $1;
    if [[ $? -eq 0 ]]; then
	ls;
    fi
}

upa() {
    up $1;
    if [[ $? -eq 0 ]]; then
	la;
    fi
}

upl() {
    up $1;
    if [[ $? -eq 0 ]]; then
	ll;
    fi
}

cd() {
    __zoxide_z "$@";
    if [[ $? -eq 0 ]]; then
	echo Entering "$PWD";
    fi
}

cds() {
    __zoxide_z "$@";
    if [[ $? -eq 0 ]]; then
	echo Entering "$PWD";
	ls;
    fi
}

cda() {
    __zoxide_z "$@";
    if [[ $? -eq 0 ]]; then
	echo Entering "$PWD";
	la;
    fi
}

cdl() {
    __zoxide_z "$@";
    if [[ $? -eq 0 ]]; then
	echo Entering "$PWD";
	ll;
    fi
}

reload() {
    source ~/.bashrc;
}

PS1='$(prompt.py "$?" $(tput cols))';

# Created by `pipx` on 2024-02-26 01:33:26
export PATH="$PATH:/home/diego/.local/bin";

# Added by me
export PATH="$PATH:/home/diego/.config/scripts";

FZF_CTRL_T_COMMAND= FZF_ALT_C_COMMAND= eval "$(fzf --bash)";
eval "$(zoxide init bash)";
