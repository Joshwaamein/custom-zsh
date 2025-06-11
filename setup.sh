#!/bin/bash
set -euo pipefail

# Configuration Options
DEFAULT_THEME="duellj"
OH_MY_ZSH_REPO="https://github.com/robbyrussell/oh-my-zsh.git"
SYNTAX_HL_REPO="https://github.com/zsh-users/zsh-syntax-highlighting.git"
TERMINAL_COLORS=(
  "background-color '#000000'"
  "foreground-color '#29B443'"
  "bold-color '#24FF00'"
)

# Color Codes
BLUE='\e[34m'
GREEN='\e[32m'
RED='\e[31m'
NC='\e[0m'

# Detect Linux Distribution
detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO_ID="${ID}"
  elif [ -f /etc/debian_version ]; then
    DISTRO_ID="debian"
  elif [ -f /etc/redhat-release ]; then
    DISTRO_ID="rhel"
  elif [ -f /etc/arch-release ]; then
    DISTRO_ID="arch"
  else
    echo -e "${RED}Error: Unsupported Linux distribution${NC}"
    exit 1
  fi
}

# Configure GNOME Terminal Colors
configure_gnome_terminal() {
  if command -v gnome-terminal &> /dev/null && command -v gsettings &> /dev/null; then
    echo -e "${BLUE}Configuring GNOME Terminal colors...${NC}"
    local PROFILE_ID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
    
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${PROFILE_ID}/ \
      use-theme-colors false
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${PROFILE_ID}/ \
      bold-color-same-as-fg false

    for color_setting in "${TERMINAL_COLORS[@]}"; do
      local key=${color_setting%% *}
      local value=${color_setting#* }
      gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${PROFILE_ID}/ \
        "$key" "$value"
    done
    echo -e "${GREEN}GNOME Terminal colors updated successfully${NC}"
  else
    echo -e "${BLUE}Skipping GNOME Terminal configuration (not detected)${NC}"
  fi
}

# Package Installation Function
install_packages() {
  local packages=("$@")
  
  case $DISTRO_ID in
    ubuntu|debian)
      sudo apt-get update
      sudo apt-get install -y "${packages[@]}"
      ;;
    fedora|rhel|centos)
      sudo dnf install -y "${packages[@]}" 2>/dev/null || sudo yum install -y "${packages[@]}"
      ;;
    arch)
      sudo pacman -S --noconfirm --needed "${packages[@]}"
      ;;
    *)
      echo -e "${RED}Error: Package installation not configured for $DISTRO_ID${NC}"
      exit 1
      ;;
  esac
}

# Main Script
echo -e "${BLUE}Starting system configuration...${NC}"
echo -e "${BLUE}Detected distribution: ${GREEN}$(source /etc/os-release && echo "$PRETTY_NAME")${NC}"

# Initial Checks
if [ "$EUID" -eq 0 ]; then
  echo -e "${RED}Error: Do not run as root${NC}"
  exit 1
fi

# Backup existing .zshrc
if [ -f "$HOME/.zshrc" ]; then
  backup_file="$HOME/.zshrc.backup-$(date +%Y%m%d%H%M%S)"
  mv -v "$HOME/.zshrc" "$backup_file"
  echo -e "${BLUE}Existing .zshrc backed up to: ${GREEN}$backup_file${NC}"
fi

# Configure GNOME Terminal
configure_gnome_terminal

# Install distribution-specific packages
case $DISTRO_ID in
  ubuntu|debian)
    install_packages zsh git fonts-powerline powerline cowsay lolcat fortune-mod
    ;;
  fedora|rhel|centos)
    install_packages zsh git powerline powerline-fonts cowsay lolcat fortune-mod
    ;;
  arch)
    install_packages zsh git powerline powerline-fonts cowsay lolcat fortune-mod
    ;;
esac

# Clone Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo -e "${BLUE}Installing Oh My Zsh...${NC}"
  git clone "$OH_MY_ZSH_REPO" "$HOME/.oh-my-zsh"
else
  echo -e "${BLUE}Oh My Zsh already installed, skipping clone${NC}"
fi

# Create new .zshrc
echo -e "${BLUE}Creating new zsh configuration...${NC}"
cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"

# Set theme
THEME="${1:-$DEFAULT_THEME}"
if [ -d "$HOME/.oh-my-zsh/themes/${THEME}.zsh-theme" ] || [ -f "$HOME/.oh-my-zsh/themes/${THEME}.zsh-theme" ]; then
  sed -i "s/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"${THEME}\"/g" "$HOME/.zshrc"
  echo -e "${BLUE}Theme set to: ${GREEN}${THEME}${NC}"
else
  echo -e "${RED}Warning: Theme ${THEME} not found, using default${NC}"
fi

# Install syntax highlighting
if [ ! -d "$HOME/.zsh-syntax-highlighting" ]; then
  echo -e "${BLUE}Installing syntax highlighting...${NC}"
  git clone --depth 1 "$SYNTAX_HL_REPO" "$HOME/.zsh-syntax-highlighting"
  echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"
fi

# Add fun greeting
echo -e "${BLUE}Adding startup greeting...${NC}"
echo "fortune | cowsay | lolcat" >> "$HOME/.zshrc"

# Change default shell
if [[ "$SHELL" != *zsh ]]; then
  echo -e "${BLUE}Changing default shell to zsh...${NC}"
  sudo chsh -s "$(which zsh)" "$USER"
  echo -e "${GREEN}Shell changed! Please log out and back in, or run:"
  echo -e "  ${BLUE}exec zsh${NC}"
else
  echo -e "${BLUE}zsh is already the default shell${NC}"
fi

echo -e "${GREEN}Configuration complete!${NC}"
sleep 5
