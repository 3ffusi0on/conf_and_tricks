#!/usr/bin/env sh

# This script install the wall configuration stored in the repository
#
# It might require the administrater acces in order to install the
# missings modules or packages.
#

#DEBUG
HOME="/tmp"

##############
# Functions
##############
function check_package {
    x=`pacman -Qs $1`
    if [ -n "$x" ]
        then return
        else sudo pacman -S $1
    fi
}

##############
# Copy files
##############

# Git
######
echo "Configuring git..."
check_package "git"
cp ./git/gitconfig $HOME/.gitconfig

# Awesome wm
#############
echo "Configuring awesome wm..."
check_package "vicious"
mkdir -p $HOME/.config
cp -r ./awesome $HOME/.config

# vim
######
echo "Configuring vim..."
check_package "vim"
cp ./vim/vimrc $HOME/.vimrc
cp -r ./vim/vimconfig $HOME/.vim

# zsh
######
echo "Configuring zsh..."
check_package "zsh"
cp ./zsh/zshrc $HOME/.zshrc


echo "Work finished ! Enjoy ;-)"
