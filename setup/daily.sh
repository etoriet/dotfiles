#!/usr/bin/env bash

set -euCo pipefail

check_command () {
    local CMD="$1"
    if ! command -v "$CMD" &> /dev/null ; then
        echo "Error: $CMD is not installed." >&2
        exit 1
    fi
}
for cmd in cd dirname pwd cp emacs date; do
    check_command "$cmd"
done

SOURCE_DIR="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd -P)"
if [ "$SOURCE_DIR" != "$HOME/dotfiles/setup" ] ; then
    echo "please set dotfiles at home dir $HOME"
    exit 1
fi


echo "installing daily command..."
mkdir -p "$HOME/bin"
cp -i "$SOURCE_DIR/../bin/daily" "$HOME/bin/daily"

echo "initializing daily files..."
mkdir -p "$HOME/Documents/timing"
cp -i "$SOURCE_DIR/../templates/timing.org.template" "$HOME/Documents/timing/timing.org"
cp -i "$SOURCE_DIR/../templates/TODO.txt.template" "$HOME/Documents/timing/TODO.txt"
