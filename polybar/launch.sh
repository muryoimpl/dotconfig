#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
# polybar -c $HOME/.config/polybar/config myi3 -r &

tray_pos=none

if type "xrandr"; then
  for m in $(polybar --list-monitors | cut -d":" -f1); do
    if [[ $m == "eDP1" ]]; then
      tray_pos=right
    fi
    MONITOR=$m TRAY_POSITION=$tray_pos polybar -c $HOME/.config/polybar/config myi3 -r &
  done
else
  polybar -c $HOME/.config/polybar/config myi3 -r &
fi

echo "Polybar launched..."
