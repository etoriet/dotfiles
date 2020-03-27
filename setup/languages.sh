#!/usr/bin/env bash

set -euC
set -o pipefail

SOURCE_DIR="$(cd $(dirname "${BASH_SOURCE}") && pwd -P)"
if [ "$SOURCE_DIR" != "$HOME/dotfiles/setup" ] ; then
    echo "please set dotfiles at home dir $HOME"
    exit 1
fi


setup_rust () {
    if [ -d "$HOME/.cargo" ] ; then
        echo "[skip] rust is installed"
        return 0
    fi

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

setup_node () {
    if [ -d "$HOME/.nvm" ] ; then
        echo "[skip] nvm is installed"
        return 0
    fi

    git clone https://github.com/nvm-sh/nvm.git .nvm
}

cd "$HOME"
setup_rust
setup_node
