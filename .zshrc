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

export EDITOR="lvim"
export KEYID="0x4b7228cfe59b7380"
export MICHI="0x3B6861376B6D3D78"
export PATH="$PATH:/home/tobias/.yarn/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias ll="exa -la --icons"
alias ls="exa --icons"
alias vim="lvim"
alias r="ranger"
alias zshrc="vim ~/.dotfiles/.zshrc"
alias viminit="vim ~/.dotfiles/init.vim"
alias i3config="vim ~/.dotfiles/manjaro/config"

[ -f "/home/tobias/.ghcup/env" ] && source "/home/tobias/.ghcup/env" # ghcup-env

export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

eval "$(direnv hook bash)"

# Functions
encrypt() {
    echo $2 | gpg --armor --clearsign | gpg --encrypt --armor --recipient $1
}

decrypt() {
    MESSAGE="$(echo $1 | gpg --decrypt --armor)"
    echo $MESSAGE | gpg --verify
    echo $MESSAGE
}


encrypt_file () {
        output=~/"${1}".$(date +%s).enc
        gpg --encrypt --armor --output ${output} -r ${2} "${1}" && echo "${1} -> ${output}"
}

decrypt_file () {
        output=$(echo "${1}" | rev | cut -c16- | rev)
        gpg --decrypt --output ${output} "${1}" && echo "${1} -> ${output}"
}
