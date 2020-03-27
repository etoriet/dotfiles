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
# openssl installed by homebrew
export PATH="$HOME/homebrew/opt/openssl/bin:$PATH"
export PATH="$HOME/homebrew/opt/util-linux/bin:$PATH"
export PATH="$HOME/homebrew/opt/util-linux/sbin:$PATH"
# home/bin
export PATH="$HOME/bin:$PATH"


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
# TBD
