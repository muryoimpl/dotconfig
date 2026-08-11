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

# 第 2 引数に no-notify を渡すと waybar へのシグナル送出を抑止する。
# autostart の apply は waybar 起動と並列に走るため、まだ SIGRTMIN+1 の
# ハンドラを登録していない起動途中の waybar に当たると、リアルタイム
# シグナルのデフォルト動作（プロセス終了）で waybar が静かに死ぬ。
# 起動直後の表示は custom/scroll の "exec" (status) が担うので通知は不要。
apply() {
    profile="$1"
    notify="${2:-notify}"

    if [ "$profile" = fine ]; then
        mmsg dispatch "setoption,axis_scroll_factor,$FINE" >/dev/null
    else
        mmsg dispatch "setoption,axis_scroll_factor,$NORMAL" >/dev/null
    fi
    echo "$profile" > "$STATE"

    if [ "$notify" = notify ]; then
        pkill -RTMIN+"$WAYBAR_SIGNAL" waybar
    fi
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
        apply "$(current)" no-notify
        ;;
esac
