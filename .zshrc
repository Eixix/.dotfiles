# Use powerline
USE_POWERLINE="true"

source ~/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
antigen bundle jessarcher/zsh-artisan

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

plugins=(
    artisan
    composer
    git
)

# Tell Antigen that you're done.
antigen apply

# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi

export EDITOR="nvim"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias ll="ls -la"
alias vim="nvim"
alias r="ranger"
alias zshrc="vim ~/.dotfiles/.zshrc"
alias viminit="vim ~/.dotfiles/init.vim"

[ -f "/home/tobias/.ghcup/env" ] && source "/home/tobias/.ghcup/env" # ghcup-env
