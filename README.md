# Custom ZSH Configuration Script for Linux

This script automates the setup of Zsh with Oh My Zsh and additional customisations on Linux systems.

## Features

- Installs Zsh and necessary dependencies
- Sets up Oh My Zsh with a custom theme
- Configures syntax highlighting
- Installs and sets up fun utilities like fortune, cowsay, and lolcat

## Prerequisites

- A fresh install of a Debian or Red hat based system.
- Sudo privileges

## Usage
### Download the script and pipe to bash. Do not run the script with Sudo. 
### Ubuntu
curl -sSL https://raw.githubusercontent.com/Joshwaamein/custom-zsh/main/ubuntu.sh | bash
### Ubuntu with GNOME Terminal
curl -sSL https://raw.githubusercontent.com/Joshwaamein/custom-zsh/main/ubuntu-gnome-terminal.sh | bash
### Redhat
curl -sSL https://raw.githubusercontent.com/Joshwaamein/custom-zsh/main/redhat.sh | bash

## GUI Customisation

If using a desktop enviromnent it is *highly* reccomended to change your terminal environment colours to:
- Background: #000000
- Text: #29B443
- Bold Text: #24FF00

You can use the file ubuntu-gnome-terminal.sh to do this automatically.

![neo matrix](https://imgs.search.brave.com/ugavthcFrw8QDSKYgkLRkVgY2kbT3ZelPsfMaDVwNw4/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93YWxs/cGFwZXJjYXZlLmNv/bS93cC93cDgwNjM4/MTEuanBn)
