#!/bin/sh
# 各 tmux window について、いずれかの pane の前面コマンドが claude なら
# window option @has-claude=1、そうでなければ 0 を設定する。
# 出力は空（status 表示には影響しない）。
tmux list-windows -a -F '#{window_id}' 2>/dev/null | while IFS= read -r wid; do
  if tmux list-panes -t "$wid" -F '#{pane_current_command}' 2>/dev/null \
       | grep -qx claude; then
    flag=1
  else
    flag=0
  fi
  tmux set-option -w -t "$wid" @has-claude "$flag" >/dev/null 2>&1
done
