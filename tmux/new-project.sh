#!/usr/bin/env bash
# One tmux session per project: claude on the left, shell on the right.
set -euo pipefail

dir=$(realpath -m "${1/#\~/$HOME}")
if [ ! -d "$dir" ]; then
  tmux display-message "no such dir: $dir"
  exit 0
fi

# tmux treats . and : in session names as target separators
name=$(basename "$dir" | tr '.:' '__')

if ! tmux has-session -t "=$name" 2>/dev/null; then
  tmux new-session -d -s "$name" -n "$name" -c "$dir"
  tmux split-window -h -t "=$name:1" -c "$dir"
  tmux send-keys -t "=$name:1.1" claude Enter
  tmux select-pane -t "=$name:1.1"
fi

tmux switch-client -t "=$name"
