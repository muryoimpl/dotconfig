#!/bin/bash

HOSTNAME=$(hostname)

if [[ "$HOSTNAME" == *"work"* ]]; then
  wlr-randr --output HDMI-A-1 --preferred --pos 7680,0 --transform 90 \
            --output DP-1 --preferred --pos 3840,400 \
            --output DP-2 --preferred --pos 0,400

  echo 'screenlayout: work'
else
  wlr-randr --output HDMI-A-1 --preferred --pos 0,400 \
            --output DP-1 --preferred --pos 3840,400 \
            --output DP-3 --preferred --pos 7680,0 --transform 90

  echo 'screenlayout: default'
fi
