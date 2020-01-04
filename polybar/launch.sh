#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
# polybar -c $HOME/.config/polybar/config myi3 -r &

if type "xrandr"; then
  for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar -c $HOME/.config/polybar/config myi3 -r &
  done
else
  polybar -c $HOME/.config/polybar/config myi3 -r &
fi

echo "Polybar launched..."
