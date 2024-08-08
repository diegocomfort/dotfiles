#!/usr/bin/env python

from shutil import get_terminal_size
from getpass import getuser
from os import getcwd, environ
from sys import argv
import subprocess
import re

class Color:
    def __init__(self, r, g, b):
        self.r = r
        self.g = g
        self.b = b

# Set up with colors
(width, height) = get_terminal_size()
exit_code = 0
if len(argv) > 1:
    exit_code = int(argv[1]) # $?
if len(argv) > 2:
    width = int(argv[2]) # uses tput
colors = [
    Color(94,30,5),
    Color(158,99,57),
    Color(160,151,144),
    Color(131,166,198),
    Color(87,154,207),
    Color(1,120,183),
    Color(2,101,160),
    Color(2,83,131),
    Color(2,65,106),
    Color(0,45,74),
]
N = len(colors)
steps = width // (N-1)

# Create gradient
gradient = []
for i in range(N - 1):
    current_color = colors[i]
    next_color    = colors[i + 1]
    # interpolate colors
    for step in range(steps):
        r = current_color.r + step * (next_color.r - current_color.r) / steps
        g = current_color.g + step * (next_color.g - current_color.g) / steps
        b = current_color.b + step * (next_color.b - current_color.b) / steps
        color = Color(r, g, b)
        gradient.append(color);

while len(gradient) < width:
    gradient.append(Color(0,45,74))

# Create prompt
name = str(subprocess.run(["whoami"], capture_output=True).stdout)[2:-3]
cwd = getcwd()
homedir = environ["HOME"]
if (len(name) + 1 + len(cwd) > width):
	cwd = cwd.replace(homedir, "~")
if (len(name) + 1 + len(cwd) > width):
	dirs = cwd.split("/")
	chars = int(((width - 1 - len(name)) - len(dirs[-1]) - len(dirs)) / (len(dirs) - 2))
	for i in range(len(dirs) - 1):
		dirs[i] = dirs[i][0:chars]
	cwd = "/".join(dirs)
message = name
message += " " * (width - len(name) - len(cwd))
message += cwd
if len(message) > width:
    message = "*" * width
while len(message) < width:
    message += " "

# Gradientify the prompt
def color_string_bg(color, string):
    return "\033[48;2;%d;%d;%dm%s\033[0m" % (color.r, color.g, color.b, string)

def color_string_fg(color, string):
    return "\033[38;2;%d;%d;%dm%s\033[0m" % (color.r, color.g, color.b, string)

prompt = ""
for i in range(width):
    prompt += color_string_bg(gradient[i], message[i])

print(prompt)

# Print exit code and '$' or '#'
exit_string = "%03d" % exit_code
if exit_code == 0:
    color = Color(0, 255, 0)
else:
    color = Color(255, 0, 0)
if name == "root":
    print("%s # " % color_string_fg(color, exit_string))
else:
    print("%s $ " % color_string_fg(color, exit_string))

