#!/usr/bin/env bash

set -euCo pipefail

check_command () {
    local CMD="$1"
    if ! command -v "$CMD" &> /dev/null ; then
        echo "Error: $CMD is not installed." >&2
        exit 1
    fi
}
for cmd in cd dirname pwd readlink ln cp; do
    check_command "$cmd"
done

SOURCE_DIR="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd -P)"
if [ "$SOURCE_DIR" != "$HOME/dotfiles/setup" ] ; then
    echo "please set dotfiles at home dir $HOME"
    exit 1
fi


put_local () {
    local FILE="$1"
    if [ ! -e "$SOURCE_DIR/../$FILE" ] ; then
        cp "$SOURCE_DIR/../${FILE}.template" "$SOURCE_DIR/../${FILE}"
        echo "[task] please edit: $SOURCE_DIR/../${FILE}"
    else
        echo "[skip] creating $FILE"
    fi
}

check_and_symlink () {
    local FILE="$1"
    local TARGET="$HOME/$FILE"
    local LINK_TARGET="$HOME/dotfiles/$FILE"

    if [ -L "$TARGET" ]; then
        local CURRENT_LINK
        CURRENT_LINK=$(readlink "$TARGET")
        if [ "$CURRENT_LINK" = "$LINK_TARGET" ] || [ "$CURRENT_LINK" = "dotfiles/$FILE" ]; then
            echo "[skip] setting $FILE"
            return
        fi
    fi

    if [ ! -e "$TARGET" ]; then
        echo "putting $FILE symlink"
        ln -s "$LINK_TARGET" "$TARGET"
    elif [ -f "$TARGET" ] || [ -d "$TARGET" ]; then
        echo "$TARGET already exists. please remove it first."
        return 1
    else
        echo "unknown status $FILE"
        return 1
    fi
}


local_files=(.gitconfig .bash_profile)
for file in "${local_files[@]}"; do
    put_local "${file}.local"
done

symlink_files=(.bash_profile .bash_profile.local .emacs .emacs.d .gitconfig .gitconfig.local .gitignore_global .gitcommit_template .Brewfile)
for file in "${symlink_files[@]}"; do
    check_and_symlink "$file"
done
