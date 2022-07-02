#!/bin/bash

# Execute with "sudo bash install.sh"

echo "Enter your user username"
read $USER
echo "Enter your user password"
read $PW

yes | sudo -u $USER install_pulse
yes | pacman -Syu
yes | pacman -S git neovim numlockx yubikey-manager-qt yubikey-personalization-gui yubioath-desktop whatsapp-for-linux visual-studio-code-bin spotify thunderbird telegram-desktop signal-desktop google-chrome dolphin direnv exa neovim
yes | sudo -u $USER sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

sudo -u $USER rm $HOME/.zshrc $HOME/.Xresources
sudo -u $USER ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc
sudo -u $USER ln -s $HOME/.dotfiles/.Xresources $HOME/.Xresources
sudo -u $USER rm $HOME/.i3/config
sudo -u $USER ln -s $HOME/.dotfiles/config $HOME/.i3/config

# GPG keys
$KEYID="0x4b7228cfe59b7380"
sudo -u $USER gpg --recv $KEYID
sudo -u $USER echo -e "5\ny\n" | gpg --command-fd 0 --edit-key "$KEYID" trust

# Configure for git
sudo -u $USER git config --global user.signingkey "$KEYID"
sudo -u $USER git config --global commit.gpgsign true

# Add Yubikey PAM auth to all configs
$PAM_LINE="auth sufficient pam_u2f.so"
echo $PAM_LINE >> /etc/pam.d/sudo
echo $PAM_LINE >> /etc/pam.d/polkit-1
echo $PAM_LINE >> /etc/pam.d/lightdm
echo $PAM_LINE >> /etc/pam.d/i3lock
