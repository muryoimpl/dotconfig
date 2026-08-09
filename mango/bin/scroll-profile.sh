#!/bin/sh
# トラックボール等（トラックパッド以外のポインタ）のスクロール量を 2 値でトグルする。
# 主目的は Chrome の Ctrl+ホイールズームが一気に何段も飛ぶのを抑えること。
# mango の axis_scroll_factor を mmsg 経由で一時変更し、状態は runtime dir に持つ。
# waybar の custom/scroll モジュールから status / toggle を呼ぶ。
#
# FINE は roundf(120 * factor) が 120 を割り切る値にすると N ノッチで 1 ズーム段になる。
#   0.5 -> 2 ノッチ / 0.33 -> 3 ノッチ / 0.25 -> 4 ノッチ

NORMAL=1.0
FINE=0.33
STATE="${XDG_RUNTIME_DIR:-/tmp}/mango-scroll-profile"
WAYBAR_SIGNAL=1

current() {
    if [ -r "$STATE" ]; then cat "$STATE"; else echo normal; fi
}

apply() {
    if [ "$1" = fine ]; then
        mmsg dispatch "setoption,axis_scroll_factor,$FINE" >/dev/null
    else
        mmsg dispatch "setoption,axis_scroll_factor,$NORMAL" >/dev/null
    fi
    echo "$1" > "$STATE"
    pkill -RTMIN+"$WAYBAR_SIGNAL" waybar
}

case "${1:-status}" in
    status)
        if [ "$(current)" = fine ]; then
            printf '{"text":"󰍽","class":"fine","tooltip":"scroll x%s (fine)"}\n' "$FINE"
        else
            printf '{"text":"󰍽","class":"normal","tooltip":"scroll x%s (normal)"}\n' "$NORMAL"
        fi
        ;;
    toggle)
        if [ "$(current)" = fine ]; then apply normal; else apply fine; fi
        ;;
    apply)
        apply "$(current)"
        ;;
esac
