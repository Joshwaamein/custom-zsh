#!/bin/bash

echo -e "\e[34mThis script will configure your zsh. Do not run this script as sudo. This script should only be run on a fresh install of Ubuntu. You can cancel the script within the next 5 seconds\e[0m"
sleep 5

echo -e "\e[34mCurrent user is $USER\e[0m"

if [ "$EUID" -eq 0 ]; then
  echo -e "\e[34mPlease do not run as root\e[0m"
  exit 1
fi

# Get the default profile ID
PROFILE_ID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")

# Set the colors
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ use-theme-colors false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ background-color '#000000'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ foreground-color '#29B443'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ bold-color '#24FF00'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ bold-color-same-as-fg false

echo -e "\e[34mGNOME Terminal colors have been updated.\e[0m"

if [ -f "$HOME/.zshrc" ]; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
    echo -e "\e[34mExisting .zshrc backed up to .zshrc.backup\e[0m"
fi

echo -e "\e[34mPatching OS\e[0m"
sudo apt-get update
sudo apt-get upgrade -y

echo -e "\e[34mInstall prerequisite packages (ZSH, git, powerline & powerline fonts)\e[0m"
sudo apt-get install zsh git powerline fonts-powerline -y

echo -e "\e[34mInstalling fortune, cowsay, lolcat\e[0m"
sudo apt-get install fortune cowsay lolcat -y

echo -e "\e[34mClone the Oh My Zsh Repo to current working directory\e[0m"
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

echo -e "\e[34mCreate a New ZSH configuration file\e[0m"
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

echo -e "\e[34mChange your Default Shell\e[0m"
sudo chsh -s $(which zsh) $USER

echo -e "\e[34mSetting Preferred Theme\e[0m"
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="duellj"/g' "$HOME/.zshrc"

echo -e "\e[34mConfigure Syntax Highlighting\e[0m"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting" --depth 1
echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"

echo -e "\e[34mAdding cow :)\e[0m"
echo "fortune | cowsay | lolcat" >> "$HOME/.zshrc"

echo -e "\e[34mShell changed to zsh. Please log out and log back in for the changes to take effect. Alternatively run 'exec zsh'\e[0m"
echo -e "\e[34mPlease open a new terminal window to see the changes.\e[0m"
sleep 5