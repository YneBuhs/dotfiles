# Why 2?
export PATH="/usr/local/sbin:$PATH"
export PATH="$(brew --prefix qt@5.5)/bin:$PATH"
# Loads nvm and bash_completion
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
# Path to your oh-my-zsh installation.
export ZSH="/Users/sophiahubeny/.oh-my-zsh"
# OhMyZsh Theme
ZSH_THEME="dracula"
# OhMyZsh plugins
plugins=(
  git
)
# Source the other file with sensitive information
source $HOME/Workspace/dotfiles/.zshrc.local
source $ZSH/oh-my-zsh.sh
source $HOME/Workspace/dotfiles/.zsh_aliases
