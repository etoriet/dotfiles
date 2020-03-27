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
echo "install gitlab-runner"
curl --output "$HOME/bin/gitlab-runner" https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-darwin-amd64
chmod +x "$HOME/bin/gitlab-runner"
# TODO gcloud
