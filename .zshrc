# Use powerline
USE_POWERLINE="true"

# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi

export EDITOR="nvim"
export KEYID="0x4b7228cfe59b7380"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias ll="exa -la --icons"
alias ls="exa --icons"
alias vim="nvim"
alias r="ranger"
alias zshrc="vim ~/.dotfiles/.zshrc"
alias viminit="vim ~/.dotfiles/init.vim"
alias i3config="vim ~/.dotfiles/manjaro/config"

[ -f "/home/tobias/.ghcup/env" ] && source "/home/tobias/.ghcup/env" # ghcup-env

export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

eval "$(direnv hook bash)"
