#!/bin/bash

if [ ! -e /sys/class/power_supply/BAT0 ]; then
  echo ''
  return
fi

array=(`cat /sys/class/power_supply/BAT0/uevent | grep --color=never 'POWER_SUPPLY_CAPACITY=' | tr '=' ' '`)
last_index=`expr ${#array[@]} - 1`
remaining=${array[${last_index}]}
icon=''

# echo $remaining

if [ $remaining -ge 90 ]; then
  icon=" %{F#98c379} "
fi

if [ $remaining -ge 20 ] && [ $remaining -lt 90 ]; then
  icon=" %{F#98c379} "
fi

if [ $remaining -ge 5 ] && [ $remaining -lt 20 ]; then
  icon=" %{F#e5c07b} "
fi

if [ $remaining -lt 5 ]; then
  echo " %{F#e06c75} "
  notify-send 'Warning!' 'Low Battery' -i ~/.config/dunst/test.jpg
fi

echo $icon
