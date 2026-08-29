#!/bin/sh
# noctalia の caffeine (アイドル抑止) 状態を waybar の custom モジュール向けに
# JSON で出力し続ける常駐スクリプト。
#
# caffeine の状態を外から取る手段はこれしかない。noctalia msg status が返すのは
# barVisible / panelOpen / activePanelId / locked だけで caffeine を含まず、
# [hooks] にも caffeine 用のフックが無い。一方 caffeine が ON の間は logind に
# "Caffeine" という idle block inhibitor が登録されるので、そこから読む。
#
# logind の BlockInhibited プロパティ ("" <-> "idle") は変化時に
# PropertiesChanged を飛ばすため、これを起点にすればポーリングが要らない。
# ただし BlockInhibited は全アプリの合算値なので、他アプリのアイドル抑止と
# 取り違えないよう、判定そのものは systemd-inhibit の noctalia の行で行う。
#
# gdbus monitor 自体はパイプ先でも行ごとに flush するが、GNU sed は出力先が tty で
# ないとブロックバッファするので -u が要る (power-profile-notify.sh と同じ理由)。

emit() {
    if systemd-inhibit --list --no-legend --no-pager 2>/dev/null |
        awk '$1 == "noctalia" && $6 == "idle" && $NF == "block" { found = 1 }
             END { exit !found }'
    then
        printf '{"alt":"on","tooltip":"Caffeine: ON (アイドル抑止中)","class":"on"}\n'
    else
        printf '{"alt":"off","tooltip":"Caffeine: OFF","class":"off"}\n'
    fi
}

# 起動直後は PropertiesChanged が来ないので、現在値を一度出しておく。
emit

gdbus monitor --system \
    --dest org.freedesktop.login1 \
    --object-path /org/freedesktop/login1 |
    sed -un "/'BlockInhibited'/p" |
    while IFS= read -r _; do
        emit
    done
