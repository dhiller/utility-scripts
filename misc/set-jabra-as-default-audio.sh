#!/bin/bash

set -euo pipefail

# set default pulseaudio devices
pactl set-default-sink $(pactl list short sinks | grep 'Jabra' | awk '{ print $1}')
pactl set-default-source $(pactl list short sources | grep 'Jabra.*mono' | awk '{ print $1}')

