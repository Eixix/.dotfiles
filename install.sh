#!/bin/bash
yes | install_pulse
yes | pacman -Syu
yes | pacman -S git neovim numlockx yubikey-manager-qt yubikey-personalization-gui yubioath-desktop whatsapp-for-linux visual-studio-code-bin spotify thunderbird telegram-desktop signal-desktop google-chrome dolphin direnv exa neovim
yes | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

$HOME_DIR="/home/tobias"
rm $HOME_DIR/.zshrc $HOME_DIR/.Xresources
ln -s $HOME_DIR/.dotfiles/.zshrc $HOME_DIR/.zshrc
ln -s $HOME_DIR/.dotfiles/.Xresources $HOME_DIR/.Xresources
rm $HOME_DIR/.i3/config
ln -s $HOME_DIR/.dotfiles/config $HOME_DIR/.i3/config

source $HOME_DIR/.zshrc

# GPG keys
gpg --recv $KEYID
echo -e "5\ny\n" | gpg --command-fd 0 --edit-key "$FP" trust

# Configure for git
git config --global user.signingkey "0x4b7228cfe59b7380"
git config --global commit.gpgsign true

# Add Yubikey PAM auth to all configs
$PAM_LINE="auth sufficient pam_u2f.so"
echo $PAM_LINE >> /etc/pam.d/sudo
echo $PAM_LINE >> /etc/pam.d/polkit-1
echo $PAM_LINE >> /etc/pam.d/lightdm
echo $PAM_LINE >> /etc/pam.d/i3lock
