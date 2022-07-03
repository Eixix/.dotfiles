#!/bin/bash

# Execute with "sudo bash install.sh"

echo "Enter your user username"
read $USER

sed -i 's/#EnableAUR/EnableAUR/' /etc/pamac.conf

yes | sudo -u $USER install_pulse
pacman -Syu --noconfirm
pacman -S git numlockx yubikey-manager-qt yubikey-personalization-gui yubioath-desktop thunderbird telegram-desktop signal-desktop dolphin direnv exa neovim --noconfirm
pamac install whatsapp-for-linux visual-studio-code-bin google-chrome
yes | sudo -u $USER sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# GPG keys
KEYID="0x4b7228cfe59b7380"
sudo -u $USER gpg --recv $KEYID
sudo -u $USER echo -e "5\ny\n" | gpg --command-fd 0 --edit-key "$KEYID" trust

# Configure for git
sudo -u $USER git config --global user.signingkey "$KEYID"
sudo -u $USER git config --global commit.gpgsign true

# Clone from repository
git clone git@github.com:Eixix/.dotfiles.git
sudo -u $USER rm $HOME/.zshrc $HOME/.Xresources
sudo -u $USER ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc
sudo -u $USER ln -s $HOME/.dotfiles/.Xresources $HOME/.Xresources
sudo -u $USER rm $HOME/.i3/config
sudo -u $USER ln -s $HOME/.dotfiles/config $HOME/.i3/config

# Add Yubikey PAM auth to all configs
PAM_LINE="auth sufficient pam_u2f.so"
echo $PAM_LINE >> /etc/pam.d/sudo
echo $PAM_LINE >> /etc/pam.d/polkit-1
echo $PAM_LINE >> /etc/pam.d/lightdm
echo $PAM_LINE >> /etc/pam.d/i3lock

while true; do
    read -p "Do you wish to install Discord? " yn
    case $yn in
        [Yy]* ) pamac install discord --no-confirm; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
  done

while true; do
    read -p "Do you wish to install Steam? " yn
    case $yn in
        [Yy]* ) pamac install steam-manjaro --no-confirm; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
  done

while true; do
    read -p "Do you wish to install Corsair drivers? " yn
    case $yn in
        [Yy]* ) pamac install ckb-next --no-confirm; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
  done
