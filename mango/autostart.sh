#! /bin/bash

# need to install
# - waybar
# - swaybg
# - swaymsg
# - swaync
# - swayosd
# - wl-clip-persist
# - wl-paste
# - network-manager
# - fcitx5
# - 1password
# - blueman
# - xfce-polkit

set +e

swaybg -i ~/.config/mango/Ju5PuBC-arch-linux-wallpaper.jpg -m fill >/dev/null 2>&1 &

waybar -c ~/.config/waybar/config.mango.jsonc -s ~/.config/waybar/style.css >/dev/null 2>&1 &

# message
swaymsg layout default >/dev/null 2>&1 &

# notification
swaync >/dev/null 2>&1 &

# keep clipboard content
wl-clip-persist --clipboard regular --reconnect-tries 0 >/dev/null 2>&1 &

# clipboard content manager
wl-paste --type text --watch cliphist store >/dev/null 2>&1 &

# network manager
nm-applet --indicator >/dev/null 2>&1 &

# IME
fcitx5 -d >/dev/null 2>&1 &

# password manager
1password --silent >/dev/null 2>&1 &

# bluetooth
blueman-applet >/dev/null 2>&1 &

# screen layout
~/.config/screenlayout/default.sh >/dev/null 2>&1 &

# Permission authentication
/usr/lib/xfce-polkit/xfce-polkit >/dev/null 2>&1 &

# change light and volume value by swayosd-client
swayosd-server >/dev/null 2>&1 &
