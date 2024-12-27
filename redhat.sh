#!/bin/bash

echo "This script will configure your zsh. Do not run this script as sudo. This script should only be run on a fresh install of Amazon Linux. You can cancel the script within the next 5 seconds"
sleep 5

echo "Current user is $USER"

if [ "$EUID" -eq 0 ]; then
  echo "Please do not run as root"
  exit 1
fi

echo "Patching OS"
sudo yum update -y

echo "Install prerequisite packages (ZSH, powerline & powerline fonts)"
sudo yum install zsh git -y
sudo yum install python3-pip -y
sudo pip3 install powerline-status

echo "Installing fortune, cowsay, lolcat"
sudo yum install epel-release -y
sudo yum install fortune-mod cowsay -y
sudo pip3 install lolcat

echo "Clone the Oh My Zsh Repo to current working directory"
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

echo "Create a New ZSH configuration file"
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

echo "Change your Default Shell"
sudo chsh -s $(which zsh) $USER

echo "Setting Preferred Theme"
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="duellj"/g' "$HOME/.zshrc"

echo "Configure Syntax Highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting" --depth 1
echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"

echo "Adding cow :)"
echo "fortune | cowsay | lolcat" >> "$HOME/.zshrc"

echo "Reload Shell"
exec zsh
