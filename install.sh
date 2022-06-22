#!/bin/bash
install_pulse
yes | sudo pacman -S git neovim numlockx yubikey-manager-qt yubikey-personalization-gui yubioath-desktop whatsapp-for-linux visual-studio-code-bin spotify thunderbird telegram-desktop signal-desktop google-chrome dolphin direnv
yes | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone git@github.com:Eixix/.dotfiles.git
rm .zshrc .Xresources
ln -s $HOME/.dotfiles/.zshrc .zshrc
ln -s $HOME/.dotfiles/.Xresources .Xresources
rm $HOME/.i3/config
ln -s $HOME/.dotfiles/config .i3/config