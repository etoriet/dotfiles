# bash setting
HISTSIZE=1000000
HISTFILESIZE=1000000000
HISTCONTROL=ignoreboth
# use bash without warning at iTerm2
export BASH_SILENCE_DEPRECATION_WARNING=1
# other command setting
export LANG=ja_JP.UTF-8
export LSCOLORS=gxfxcxdxbxegexabagacad


#### PATH
# homebrew at home dir
export PATH="$HOME/homebrew/bin:$PATH"
# home/bin
export PATH="$HOME/bin:$PATH"
# openssl installed by homebrew
export PATH="$PATH:$HOME/homebrew/opt/openssl/bin"
# mongo
export PATH="$HOME/homebrew/opt/mongodb-community@3.6/bin:$PATH"
# GCP
if [ -d "$HOME/homebrew/Caskroom/google-cloud-sdk" ] ; then
    source "$HOME/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
    source "$HOME/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"
fi


#### COMMAND
# alias
alias e="emacs -nw"
alias gs="git status"
alias ls="ls -G" # colored ls with Mac(BSD ls)
alias jq_less="jq . -C | less -R"
alias amesh='docker run -e TERM_PROGRAM --rm otiai10/amesh'

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
password_gen () {
    openssl rand -base64 27 | tr -dc A-Za-z0-9
    echo
}


#### LANGUAGES
# node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# rust
export PATH="$PATH:$HOME/.cargo/bin"

# python
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
