#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
# polybar -c $HOME/.config/polybar/config myi3 -r &

if type "xrandr"; then
  for m in $(polybar --list-monitors | cut -d":" -f1); do
    if [[ $m == "eDP1" ]]; then
      MONITOR=$m TRAY_POSITION=right polybar -c $HOME/.config/polybar/config myi3 -r &
      continue
    fi

    if [[ $m == "HDMI1" || $m == "DisplayPort-2" ]]; then
      hdmi1width=$(polybar --list-monitors | grep "HDMI1" | cut -d":" -f1 | cut -d"x" -f1)
      # if [[ $((hdmi1width)) -gt 3000 ]]; then
        MONITOR=$m TRAY_POSITION=none polybar -c $HOME/.config/polybar/config myi3hdmi1 -r &
      # else
      #  MONITOR=$m TRAY_POSITION=none polybar -c $HOME/.config/polybar/config myi3dp2 -r &
      # fi
      continue
    fi

    if [[ $m == "DP2" || $m == "DisplayPort-3" ]]; then
      MONITOR=$m TRAY_POSITION=none polybar -c $HOME/.config/polybar/config myi3dp2 -r &
      continue
    fi

    if [[ $m == "HDMI2" ]]; then
      hdmi2width=$(polybar --list-monitors | grep "HDMI2" | cut -d":" -f1 | cut -d"x" -f1)
      if [[ $((hdmi2width)) -gt 3000 ]]; then
        MONITOR=$m TRAY_POSITION=none polybar -c $HOME/.config/polybar/config myi3hdmi1 -r &
      else
        MONITOR=$m TRAY_POSITION=none polybar -c $HOME/.config/polybar/config myi3hdmi2 -r &
      fi

      continue
    fi

    MONITOR=$m TRAY_POSITION=none polybar -c $HOME/.config/polybar/config myi3 -r &
  done
else
  polybar -c $HOME/.config/polybar/config myi3 -r &
fi

echo "Polybar launched..."
