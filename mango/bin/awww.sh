#!/bin/sh
# Changes the wallpaper to a randomly chosen image in a given directory
# at a set interval.

awww-daemon >/dev/null 2>&1 &
sleep 1

IMAGE=~/.config/awww/Ju5PuBC-arch-linux-wallpaper.jpg
RESIZE_TYPE="crop"
export AWWW_TRANSITION_FPS="${AWWW_TRANSITION_FPS:-60}"
export AWWW_TRANSITION_STEP="${AWWW_TRANSITION_STEP:-2}"

awww img --resize="$RESIZE_TYPE" "$IMAGE" --transition-type center
