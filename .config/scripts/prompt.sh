#!/usr/bin/bash

# set -euxv

# stolen from https://github.com/gcholette/bash-ps1-themes
# Hex in form "#rrggbb" (base 16) to RGB in form "r" "g" "b" (base 10)
hex_to_rgb()
{
    hex=${1#"#"};
    r=$((0x${hex:0:2}));
    g=$((0x${hex:2:2}));
    b=$((0x${hex:4:2}));
    printf "%d;%d;%d" $r $g $b;
}

# RGB in form "r;g;b" (base 10) to Hex in form "#rrggbb" (base 16)
rgb_to_hex()
{
    IFS=";" read r g b <<< "$1";
    printf "#%02x%02x%02x" $r $g $b;
}

# Print a string with background color
color_string_bg()
{
    rgb=$1
    str=$2;

    printf "\[\033[48;2;${rgb}m\]${str}"
}

# Print a string with foreground color
color_string_fg()
{
    rgb=$1
    str=$2;

    printf "\[\033[38;2;${rgb}m\]${str}"
}

# Clear terminal escape color
clear_color()
{
    printf "\[\033[0m\]"
}

print_prompt()
{
    last_exit_code=$1;
    colors=("$(rgb_to_hex "94;30;5")"
	    "$(rgb_to_hex "158;99;57")"
	    "$(rgb_to_hex "160;151;144")"
	    "$(rgb_to_hex "131;166;198")"
	    "$(rgb_to_hex "87;154;207")"
	    "$(rgb_to_hex "1;120;183")"
	    "$(rgb_to_hex "2;101;160")"
	    "$(rgb_to_hex "2;83;131")"
	    "$(rgb_to_hex "2;65;106")"
	    "$(rgb_to_hex "0;45;74")");
    width=$(tput cols);
    N=${#colors[@]};
    steps=$((width / (N-1)));	# gradient "steps" between the colors in $colors

    # Create gradient as an array of colors
    declare -a gradient;
    for i in $(seq 0 $((N - 2))); do
	IFS=";" read curr_r curr_g curr_b <<< "$(hex_to_rgb ${colors[i]})";
	IFS=";" read next_r next_g next_b <<< "$(hex_to_rgb ${colors[$((i+1))]})";
	for step in $(seq 0 $((steps - 1))); do
	    r=$((curr_r + (next_r - curr_r) * step / steps));
	    g=$((curr_g + (next_g - curr_g) * step / steps));
	    b=$((curr_b + (next_b - curr_b) * step / steps));
	    gradient+=("$(rgb_to_hex "${r};${g};${b}")");
	done
    done
    while (( ${#gradient[@]} < $width )); do
	gradient+=("${colors[$((N-1))]}");
    done

    # get and shorten cwd path, if necessary
    cwd=$PWD;
    if (( ${#name} + ${#cwd} + 1 > $width )); then # use ~ for $HOME
	cwd=${cwd/"$HOME"/"~"};
    fi
    if (( ${#name} + ${#cwd} + 1 > $width )); then # shorten all parent directory names
	IFS="/" read -a dirs <<< "$cwd";
	chars=$(((width - 1 - ${#name} - ${#dirs[-1]} - ${#dirs[@]}) / (${#dirs[@]} - 2)));
	for i in $(seq $((${#dirs[@]} - 2))); do
	    old="${dirs[$i]}";
	    dirs[$i]="${old:0:$chars}";
	done
	cwd="$(IFS="/" ; echo "${dirs[*]}")";
    fi
    if (( ${#name} + ${#cwd} + 1 > $width )); then # just use the current directory name
	cwd="${PWD##*/}";
    fi

    # print prompt with gradient background
    name="$(whoami)@$HOSTNAME";
    spaces=$((width - ${#name}));
    prompt="$(printf "%s%${spaces}s" $name $cwd)";
    i=0
    for hex in "${gradient[@]}"; do
	color_string_bg $(hex_to_rgb $hex) "${prompt:$i:1}";
	i=$((i+1));
    done
    clear_color;

    # print last exit code with corresponding color: green=okay, red=fail
    last_exit_code=$(printf "%03d" $last_exit_code);
    color="255;0;0";
    if (( last_exit_code == 0 )); then
	color="0;255;0";
    fi
    color_string_fg $color $last_exit_code;
    clear_color;

    # print $/# for regular/root user
    if [[ "$(whoami)" == "root" ]]; then
	echo " # ";
    else
	echo " $ ";
    fi
}

custom_prompt()
{
    local last_exit_code="$?";
    PS1="$(print_prompt $last_exit_code)";
}
