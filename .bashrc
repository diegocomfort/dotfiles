# stdout=0
# stdin=1
# stderr=2

alias ls="eza --color=always --classify=always"
alias la="ls -a"
alias lt="ls -lgHMm --header --total-size --git"
alias llt="ls -lagHMm --header --total-size --git"
alias l="ls -lgHMm --header --git"
alias ll="ls -lagHMm --header --git"
alias t="ls -T"
alias ta="la -T"
alias tl="ll -T"

alias grep="grep --color=always"

alias copy="xclip -selection clipboard"
alias ff="fastfetch"
alias sl="sl -10 -cdwa"
alias simonsays="/usr/bin/sudo "
alias sudo="/usr/bin/sudo "
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
which() {
    if [[ $# -ne 1 ]]; then
	return 1;
    fi

    case "$(type -t $1)" in
	"alias")
	    type $1
	    ;;
	"keyword")
	    echo "$1 is a keyword"
	    help $1
	    ;;
	"builtin")
	    echo "$1 is a builtin"
	    help $1
	    ;;
	"function")
	    type $1
	    ;;
	"file")
	    path=$(/usr/bin/which $1 2>/dev/null)
	    file $(realpath $path);
	    whatis=$(whatis $1 2>/dev/null | \
			 grep -e '\(1\)' -e '\(6\)' -e '\(8\)')
	    if [[ $? -eq 0 ]]; then
		echo "$whatis";
	    fi
	    ;;
	*)
	    echo "bash: $1 not found";
	    return 1;
	    ;;
    esac
}

up() {
    if [[ $# -eq 0 ]]; then
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

upt() {
    up $1;
    if [[ $? -eq 0 ]]; then
	t;
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

cdt() {
    __zoxide_z "$@";
    if [[ $? -eq 0 ]]; then
	echo Entering "$PWD";
	t;
    fi
}

reload() {
    source ~/.bashrc;
}

exit_code() {
    code=$?;
    echo $code;
    return $code;
}

# Seems to be breaking bash
PS1='\[$(prompt.py "$?" $(tput cols))\]';

# Created by `pipx` on 2024-02-26 01:33:26
export PATH="$PATH:/home/diego/.local/bin";

# Added by me
export PATH="$PATH:/home/diego/.config/scripts";

FZF_CTRL_T_COMMAND= FZF_ALT_C_COMMAND= eval "$(fzf --bash)";
eval "$(zoxide init bash)";
