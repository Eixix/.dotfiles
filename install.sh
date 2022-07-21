#!/bin/bash

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

echo "========================================="
echo "Install Default packages and updates"
yes | sudo -u $USER install_pulse
pacman -Syu --noconfirm
pacman -S git npm numlockx rust yubikey-manager-qt yubikey-personalization-gui yubioath-desktop thunderbird telegram-desktop signal-desktop dolphin direnv exa neovim unzip yarn ttf-fira-code playerctl py3status --noconfirm 
pamac install whatsapp-for-linux visual-studio-code-bin google-chrome --no-confirm

echo "========================================="
echo "Install zsh"
yes | sudo -u $USER sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo -u $USER git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
LINE_NUMBER=$(grep -n $USER /etc/passwd | cut -f1 -d:)
sed -i "${LINE_NUMBER}s=/bin/bash=/usr/bin/zsh=" /etc/passwd

echo "========================================="
echo "Install lunarvim"
yes | sudo -u $USER bash -c "$(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)"

echo "========================================="
echo "Install fonts"
sudo -u $USER mkdir -P $HOME/.local/share/fonts
sudo -u $USER wget -O "$HOME/.local/share/fonts/MesloLGS NF Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf 
sudo -u $USER wget -O "$HOME/.local/share/fonts/MesloLGS NF Bold.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf 
sudo -u $USER wget -O "$HOME/.local/share/fonts/MesloLGS NF Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf 
sudo -u $USER wget -O "$HOME/.local/share/fonts/MesloLGS NF Bold Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf 

echo "========================================="
echo "GPG keys integration"
KEYID="0x4b7228cfe59b7380"
sudo -u $USER gpg --recv $KEYID
echo -e "5y" | sudo -u $USER gpg --command-fd 0 --edit-key "$KEYID" trust
wget -O -P $HOME/.gnupg/gpg-agent.conf https://raw.githubusercontent.com/drduh/config/master/gpg-agent.conf

# Configure for git
sudo -u $USER git config --global user.signingkey "$KEYID"
sudo -u $USER git config --global commit.gpgsign true

echo "========================================="
echo "Clone and link dotfiles"
sudo -u $USER git clone https://github.com/Eixix/.dotfiles
sudo -u $USER git -C .dotfiles remote set-url origin git@github.com:Eixix/.dotfiles.git
sudo -u $USER rm $HOME/.zshrc $HOME/.Xresources
sudo -u $USER ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc
sudo -u $USER ln -s $HOME/.dotfiles/.Xresources $HOME/.Xresources
sudo -u $USER rm $HOME/.i3/config
sudo -u $USER ln -s $HOME/.dotfiles/config $HOME/.i3/config

echo "========================================="
echo "Add Yubikey PAM auth to all configs"
sudo -u $USER pamu2fcfg > ~/.config/Yubico/u2f_keys
sudo -u $USER mkdir ~/.config/Yubico
PAM_LINE="auth sufficient pam_u2f.so"
sed -i "1 a$PAM_LINE" /etc/pam.d/sudo
sed -i "1 a$PAM_LINE" /etc/pam.d/polkit-1
sed -i "1 a$PAM_LINE" /etc/pam.d/lightdm
sed -i "1 a$PAM_LINE" /etc/pam.d/i3lock

echo "========================================="
echo "Install optional software"
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

while true; do
   read -p "Do you want to install custom boot screen? " yn
   case $yn in
        [Yy]* ) pacman -S --noconfirm bootsplash-systemd bootsplash-manager bootsplash-theme-illyria; sudo bootsplash-manager --set "illyria"; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
   esac
done

echo "========================================="
echo "Rebooting"
while true; do
  read -p "Do you want to reboot now? " yn
  case $yn in
    [Yy]* ) shutdown -r now; break;;
    [Nn]* ) break;;
    * ) echo "Please answer yes or no.";;
  esac
done
