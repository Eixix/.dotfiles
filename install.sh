#!/bin/bash

# TODO: Fonts, NVM, LVIM

# Execute with "sudo bash install.sh"
while true; do
  echo "Enter your user username"
  read USER

  HOME="/home/$USER"

  if [ -d "$HOME" ]; then
    break
  else
    echo "User does not exist, enter a real user"
  fi
done

sed -i 's/#EnableAUR/EnableAUR/' /etc/pamac.conf

echo "=========================================\n"
echo "Install Default packages and updates\n"
yes | sudo -u $USER install_pulse
pacman -Syu --noconfirm
pacman -S git numlockx rust yubikey-manager-qt yubikey-personalization-gui yubioath-desktop thunderbird telegram-desktop signal-desktop dolphin direnv exa neovim --noconfirm
pamac install whatsapp-for-linux visual-studio-code-bin google-chrome --no-confirm

echo "=========================================\n"
echo "Install zsh\n"
yes | sudo -u $USER sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "=========================================\n"
echo "Install npm and node\n"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | sudo -u $USER bash
source $HOME/.bashrc
sudo -u $USER nvm install --lts

echo "=========================================\n"
echo "Install lunarvim\n"
sudo -u $USER bash "$(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)" -y

echo "=========================================\n"
echo "GPG keys integration\n"
KEYID="0x4b7228cfe59b7380"
sudo -u $USER gpg --recv $KEYID
echo -e "5\ny\n" | sudo -u $USER gpg --command-fd 0 --edit-key "$KEYID" trust

# Configure for git
sudo -u $USER git config --global user.signingkey "$KEYID"
sudo -u $USER git config --global commit.gpgsign true

echo "=========================================\n"
echo "Clone and link dotfiles\n"
sudo -u $USER git clone https://github.com/Eixix/.dotfiles
sudo -u $USER git -C .dotfiles remote set-url origin git@github.com:Eixix/.dotfiles.git
sudo -u $USER rm $HOME/.zshrc $HOME/.Xresources
sudo -u $USER ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc
sudo -u $USER ln -s $HOME/.dotfiles/.Xresources $HOME/.Xresources
sudo -u $USER rm $HOME/.i3/config
sudo -u $USER ln -s $HOME/.dotfiles/config $HOME/.i3/config

echo "=========================================\n"
echo "Add Yubikey PAM auth to all configs\n"
PAM_LINE="auth sufficient pam_u2f.so"
echo $PAM_LINE >> /etc/pam.d/sudo
echo $PAM_LINE >> /etc/pam.d/polkit-1
echo $PAM_LINE >> /etc/pam.d/lightdm
echo $PAM_LINE >> /etc/pam.d/i3lock

echo "=========================================\n"
echo "Install optional software\n"
while true; do
    read -p "Do you wish to install Discord? " yn
    case $yn in
        [Yy]* ) pamac install discord --no-confirm; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
  done

while true; do
    read -p "Do you wish to install Steam? " yn
    case $yn in
        [Yy]* ) pamac install steam-manjaro --no-confirm; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
  done

while true; do
    read -p "Do you wish to install Corsair drivers? " yn
    case $yn in
        [Yy]* ) pamac install ckb-next --no-confirm; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
  done
