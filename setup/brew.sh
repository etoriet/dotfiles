#!/usr/bin/env bash

set -euC
set -o pipefail

SOURCE_DIR="$(cd $(dirname "${BASH_SOURCE}") && pwd -P)"
if [ "$SOURCE_DIR" != "$HOME/dotfiles/setup" ] ; then
    echo "please set dotfiles at home dir $HOME"
    exit 1
fi


setup_brew () {
    if command -v brew >/dev/null 2>&1 ; then
        echo "brew already installed"
        return 0
    fi

    if [ -d "$HOME/homebrew" ] ; then
        echo "brew is not installed but $HOME/homebrew directory already exists. remove it first."
        return 1
    fi

    echo "installing brew to $HOME/homebrew"
    git clone https://github.com/Homebrew/brew "$HOME/homebrew"
}

install_packages () {
    if [ ! -e "$HOME/.Brewfile" ] ; then
        echo "please put $HOME/.Brewfile with setup/dotfiles.sh"
        return 1
    fi

    brew bundle --global
    # dump command: brew bundle dump --global --force
}


setup_brew
install_packages
