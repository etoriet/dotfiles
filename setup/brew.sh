#!/usr/bin/env bash

set -euCo pipefail

check_command () {
    local CMD="$1"
    if ! command -v "$CMD" &> /dev/null ; then
        echo "Error: $CMD is not installed. prepare it with OS-level package manager." >&2
        exit 1
    fi
}
for cmd in cd dirname pwd ln curl git; do
    check_command "$cmd"
done

SOURCE_DIR="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd -P)"
if [ "$SOURCE_DIR" != "$HOME/dotfiles/setup" ] ; then
    echo "please set dotfiles at home dir $HOME"
    exit 1
fi

setup_brew () {
    if command -v brew >/dev/null 2>&1 ; then
        echo "[skip] brew already installed"
        return 0
    fi

    if [ -d "$HOME/homebrew" ] ; then
        echo "brew is not installed but $HOME/homebrew directory already exists. remove it first."
        return 1
    fi

    echo "installing brew to $HOME/homebrew"
    git clone https://github.com/Homebrew/brew "$HOME/homebrew"
    # set PATH when installed
    export PATH="$HOME/homebrew/bin:$PATH"
}

put_brewfile () {
    if [ -e "$HOME/.Brewfile" ] ; then
        echo "[skip] setting Brewfile"
        return 0
    fi
    ### OS check
    if [ "$(uname)" = "Darwin" ] ; then
        export OS="mac"
    elif [ "$(uname)" = "Linux" ] ; then
        export OS="linux"
    else
        echo "unknown OS: $(uname)"
        return 1
    fi

    echo "symlinking ${OS}.Brewfile to $HOME/.Brewfile"
    ln -s "$HOME/dotfiles/${OS}.Brewfile" "$HOME/.Brewfile"
}

install_packages () {
    if [ ! -e "$HOME/.Brewfile" ] ; then
        echo "$HOME/.Brewfile not found"
        return 1
    fi

    brew bundle --global
    # dump command: brew bundle dump --global --force
}


setup_brew
put_brewfile
install_packages
