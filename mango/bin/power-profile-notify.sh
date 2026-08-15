#!/bin/sh
# パワープロファイルが変わったらデスクトップ通知を出す常駐スクリプト。
#
# waybar 組み込みの power-profiles-daemon モジュールはクリックを自前で処理するため
# on-click を通さない。代わりに tlp-pd が持つ net.hadess.PowerProfiles の
# ActiveProfile プロパティ変更を D-Bus で直接監視する。こうすると waybar クリック・
# CLI・tlp-pd の自動切替のどれで変わっても同じ経路で拾える。
#
# gdbus monitor 自体はパイプ先でも行ごとに flush するが、GNU sed は出力先が tty で
# ないとブロックバッファするので -u が要る。これが無いと通知が数分遅れる。
# 起動時に現在値は出力されないため、ログイン直後に余計な通知は出ない。

BUS=net.hadess.PowerProfiles
OBJ=/net/hadess/PowerProfiles
# 連打しても通知が積み上がらないよう、swaync の置換キーを固定する。
SYNC_KEY=power-profile

label() {
    case "$1" in
        performance) echo 'Performance' ;;
        balanced)    echo 'Balanced' ;;
        power-saver) echo 'Power saver' ;;
        *)           echo "$1" ;;
    esac
}

gdbus monitor --system --dest "$BUS" --object-path "$OBJ" |
    sed -un "s/.*'ActiveProfile': <'\([^']*\)'>.*/\1/p" |
    while IFS= read -r profile; do
        notify-send \
            -a 'Power profile' \
            -u low \
            -t 3000 \
            -i "power-profile-${profile}-symbolic" \
            -h "string:x-canonical-private-synchronous:$SYNC_KEY" \
            'Power profile' "$(label "$profile")"
    done
