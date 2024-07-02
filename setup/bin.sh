#!/usr/bin/env bash

set -euC
set -o pipefail

SOURCE_DIR="$(cd $(dirname "${BASH_SOURCE}") && pwd -P)"
if [ "$SOURCE_DIR" != "$HOME/dotfiles/setup" ] ; then
    echo "please set dotfiles at home dir $HOME"
    exit 1
fi


mkdir -p "$HOME/bin"
echo "installing scripts"
cp "$SOURCE_DIR/../bin/tac" "$HOME/bin/"
cp "$SOURCE_DIR/../bin/daily" "$HOME/bin/"
