# history setting
HISTSIZE=1000000
HISTFILESIZE=1000000000
HISTCONTROL=ignoreboth
# use bash without warning at iTerm2
export BASH_SILENCE_DEPRECATION_WARNING=1
# other command setting
export LANG=ja_JP.UTF-8

### OS check
if [ "$(uname)" = "Darwin" ] ; then
    export OS="mac"
elif [ "$(uname)" = "Linux" ] ; then
    export OS="linux"
fi

#### PATH
check_and_set_path() {
    if [ -d "$1" ] ; then
        export PATH="$1:$PATH"
    fi
}
check_and_set_path "$HOME/homebrew/bin"
check_and_set_path "$HOME/bin"
check_and_set_path "$HOME/.local/bin"
check_and_set_path "$HOME/homebrew/opt/openssl/bin"

#### COMMAND/visibility
# alias
alias e="emacs -nw"
alias gs="git status"
if [ "$OS" = "mac" ] ; then
    export LSCOLORS=gxfxcxdxbxegexabagacad
    alias ls="ls -G" # colored ls with Mac(BSD ls)
elif [ "$OS" = "linux" ] ; then
    alias ls="ls --color=auto"
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi
if command -v jq 1>/dev/null 2>&1; then
    alias jq_less="jq . -C | less -R"
fi

# cleanup command
cleanup_tilda_files () {
    NUM_FILES=$(find . -name "*~" | wc -l | awk '{print $1}')
    if [ "$NUM_FILES" = 0 ] ; then
        echo "not found"
        return 0
    else
        echo "found $NUM_FILES files"
        find . -name "*~"
        read -p "delete these? (y/N): " YN
        if [ "$YN" = y ] ; then
            find . -name "*~" -exec rm {} \;
            echo "deleted"
        fi
    fi
}

# password generator
if command -v openssl 1>/dev/null 2>&1; then
    password_gen () {
        openssl rand -base64 27 | tr -dc A-Za-z0-9
        echo
    }
fi

# random port
if command -v python3 1>/dev/null 2>&1; then
    # https://unix.stackexchange.com/questions/55913/whats-the-easiest-way-to-find-an-unused-local-port
    random_port () {
        python3 -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1])'
    }
fi

# clipboard to temporary file
if command -v pbpaste 1>/dev/null 2>&1; then
    clip_temp () {
        TEMP_FILE=$(mktemp "/tmp/clip_temp.XXXXXX")
        pbpaste >"$TEMP_FILE"
        echo >>"$TEMP_FILE"
        echo "$TEMP_FILE"
    }
fi

#### tools
# pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# direnv
if command -v direnv 1>/dev/null 2>&1; then
    eval "$(direnv hook bash)"
fi

# asdf
if [ -f "$HOME/homebrew/opt/asdf/libexec/asdf.sh" ] ; then
    source "$HOME/homebrew/opt/asdf/libexec/asdf.sh"
fi

# GCP
if [ -d "$HOME/homebrew/Caskroom/google-cloud-sdk" ] ; then
    source "$HOME/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
    source "$HOME/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"
fi

#### cleanup
unset -f check_and_set_path
unset OS

#### environment dependent settings
if [ -f "$HOME/.bash_profile.local" ] ; then
    source "$HOME/.bash_profile.local"
fi
