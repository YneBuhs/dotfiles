#!/usr/bin/env bash
# Symlinks this repo's dotfiles into $HOME.
# Safe to re-run: skips files already correctly symlinked, backs up
# anything else that's in the way.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d%H%M%S)"

# map: source (relative to repo) -> target (relative to $HOME)
LINKS=(
  ".vimrc:.vimrc"
  ".tmux.conf:.tmux.conf"
  ".zsh_aliases:.zsh_aliases"
  "nvim/init.vim:.config/nvim/init.vim"
  "claude:.claude"
)

link() {
  local src="$DOTFILES_DIR/$1"
  local dest="$HOME/$2"

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "ok      $dest -> $src"
    return
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dest" "$BACKUP_DIR/$(basename "$dest")"
    echo "backup  $dest -> $BACKUP_DIR/"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "linked  $dest -> $src"
}

for pair in "${LINKS[@]}"; do
  link "${pair%%:*}" "${pair##*:}"
done

if [ -d "$BACKUP_DIR" ]; then
  echo
  echo "Existing files backed up to $BACKUP_DIR"
fi
