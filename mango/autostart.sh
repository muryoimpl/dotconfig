#! /bin/bash

set +e

waybar -c ~/.config/waybar/config.mango.jsonc -s ~/.config/waybar/style.css &

# message
swaymsg layout default &

# notification
swaync &

# keep clipboard content
wl-clip-persist --clipboard regular --reconnect-tries 0 &

# clipboard content manager
wl-paste --type text --watch cliphist store &

# network manager
nm-applet --indicator &

# IME
fcitx5 -d

# password manager
1password --silent &

# bluetooth
blueman-applet
