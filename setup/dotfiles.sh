#!/usr/bin/env bash

set -euC
set -o pipefail

SOURCE_DIR="$(cd $(dirname "${BASH_SOURCE}") && pwd -P)"
if [ "$SOURCE_DIR" != "$HOME/dotfiles/setup" ] ; then
    echo "please set dotfiles at home dir $HOME"
    exit 1
fi


check_and_symlink () {
    local FILE="$1"
    if [ "$(readlink "$HOME/$FILE")" = "$HOME/dotfiles/$FILE" ] ; then
        echo "[skip] setting $FILE"
    elif [ "$(readlink "$HOME/$FILE")" = "dotfiles/$FILE" ] ; then
        echo "[skip] setting $FILE"
    elif [ ! -e "$HOME/$FILE" ] ; then
        echo "putting $FILE symlink"
        ln -s "$HOME/dotfiles/$FILE"
    elif [ -f "$HOME/$FILE" -o -d "$HOME/$FILE" ] ; then
        echo "$HOME/$FILE already exists. please remove it first."
        return 1
    else
        echo "unknown status $FILE"
        return 1
    fi
}


if [ ! -e "$SOURCE_DIR/../.gitconfig.local" ] ; then
    cp "$SOURCE_DIR/../.gitconfig.local.template" "$SOURCE_DIR/../.gitconfig.local"
    echo "[task] please edit before git commit: $SOURCE_DIR/../.gitconfig.local"
fi

pushd "$HOME"
check_and_symlink .bash_profile
check_and_symlink .emacs
check_and_symlink .emacs.d
check_and_symlink .gitconfig
check_and_symlink .gitconfig.local
check_and_symlink .gitignore_global
check_and_symlink .gitcommit_template
popd
