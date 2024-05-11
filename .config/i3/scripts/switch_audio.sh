#!/bin/bash

# Modified from https://ericlathrop.com/2021/02/changing-pulseaudio-outputs-programmatically/

set -e

default_sink=$(pactl get-default-sink)
sinks=$(pactl list short sinks | cut -f2)

# for wrap-around
sinks="$sinks
$sinks"

next_sink=$(echo "$sinks" | awk "/$default_sink/{getline x;print x;exit;}")

pactl set-default-sink "$next_sink"
pactl list short sink-inputs | \
  cut -f1 | \
  xargs -I{} pactl move-sink-input {} "$next_sink"

out_id=$(pactl list short sinks | awk "/$next_sink/{print \$1}")
out_name=$(pactl list sinks | grep -E "Sink #$out_id" -A 50 | awk -F= "/device.description/{print \$2}")
notify-send "Switched audio output to $out_name"
