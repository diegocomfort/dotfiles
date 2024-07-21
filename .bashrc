# stdout=0
# stdin=1
# stderr=2

alias ls='eza --color=auto --classify=always';
alias la='ls -a';
alias lt='ls -lgHMm --header --total-size --git';
alias llt='ls -lagHMm --header --total-size --git';
alias l='ls -lgHMm --header --git';
alias ll='ls -lagHMm --header --git';
alias t='ls -T';
alias ta='la -T';
alias tl='ll -T';
alias grep='grep --color=auto';
alias less='less -R';
alias objdump='objdump -M att-mnemonic,suffix'
alias ip='ip --color=auto';
alias e-nw='TERM=xterm-direct /usr/bin/emacsclient -t'
alias start_emacs='/usr/bin/emacs --daemon'
alias copy='xclip -selection clipboard';
alias paste='xclip -selection clipboard -out';
alias ff='fastfetch';
alias sl='sl -10 -cdwa';
alias simonsays='/usr/bin/sudo ';
alias sudo='/usr/bin/sudo ';
alias q='exit';
alias c='clear';
# alias cat="bat --paging=never"

# Check updates and noitfy if an update will be required
# From https://forum.manjaro.org/t/root-tip-utility-script-check-if-updates-may-require-system-restart/14112
cu() {
    reboot="(ucode|cryptsetup|linux|nvidia|mesa|systemd|wayland|xf86-video|xorg)"
    updates=$(checkupdates);
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
    if [[ $# -eq 0 ]]; then
	cat <<EOF
Usage: which [options...] commands...

Options:
	-h	print help message and exit
	-v	verbose output (default)
	-q	quiet output
EOF
	return;
    fi

    options_done=0
    options=""
    verbose=1
    quiet=0
    for arg in "$@"; do
	if (( ! options_done )); then
	    case "$arg" in
		"-h")
		    which;
		    return;
		    ;;
		"-v")
		    verbose=1;
		    quiet=0;
		    options="$options -v";
		    continue;
		    ;;
		"-q")
		    quiet=1;
		    verbose=0;
		    options="$options -q";
		    continue;
		    ;;
		*)
		    options_done=1;
		    ;;
	    esac
	fi

	if (( verbose )); then
	    echo "$arg:";
	fi
	case "$(type -t "$arg")" in
	    "alias")
		t=$(type $arg);
		if (( quiet )); then
		    echo "${t/"$arg is aliased to \`"/""}";
		else
		    echo $t;
		    t="${t/"$arg is aliased to \`"/""}";
		    t="${t::-1}";
		    cmd="$(echo "$t" | awk '{print $arg}')";
		    if [[ "$arg" = "$cmd" ]]; then
			which $options "$(/usr/bin/which "$1")";
		    else
			which $options $cmd;
		    fi
		fi
		;;
	    "keyword")
		echo "$arg is a keyword"
		if (( verbose )); then
		    help $arg;
		fi
		;;
	    "builtin")
		echo "$arg is a builtin"
		if (( verbose )); then
		    help $arg;
		fi
		;;
	    "function")
		if (( quiet )); then
		    echo "$arg is a function";
		else
		    type $arg
		fi
		;;
	    "file")
		path="$(/usr/bin/which $arg 2>/dev/null)";
		path="$(realpath $path 2>/dev/null)";
		if (( quiet )); then
		    echo $path;
		else
		    file "$path";
		    whatis=$(whatis $arg 2>/dev/null | \
				 grep -e '\(1\)' -e '\(6\)' -e '\(8\)');
		    if [[ $? -eq 0 ]]; then
			echo "$whatis";
		    fi

		    pkg="$(pacman -Qoq $path 2>/dev/null)";
		    if [[ $? -ne 0 ]]; then
			return;
		    fi

		    pacman="$(pacman -Qi $pkg 2>/dev/null)";
		    if [[ $? -eq 0 ]]; then
			echo "$pacman";
		    fi
		fi
		;;
	    *)
		if (( verbose )); then
		    echo "bash: $arg not found";
		fi
		;;
	esac
	if (( verbose )) && [[ "$arg" != "${@: -1}" ]]; then
	    echo;
	fi
    done

    return;

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

mkdir() {
    /usr/bin/mkdir $@ && cd ${@: -1};
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

r() {
    source ~/.bashrc;
}

kbd() {
    setxkbmap -option ctrl:swapcaps
    xset r rate 250
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
