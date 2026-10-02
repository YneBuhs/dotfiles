#!/usr/bin/env bash
# Menu of ~/* project dirs; picking one opens (or switches to) its session.
set -euo pipefail

open="$HOME/dotfiles/tmux/new-project.sh"
items=()
for d in "$HOME"/*/; do
  d=${d%/}
  name=$(basename "$d")
  [ "$name" = go ] && continue
  items+=("$name" "" "run-shell '$open \"$d\"'")
done
items+=("")
items+=("other path..." "/" "command-prompt -I '#{pane_current_path}' -p 'project dir:' \"run-shell '$open \\\"%%\\\"'\"")

tmux display-menu -T "#[align=centre] projects " -x C -y C "${items[@]}"
