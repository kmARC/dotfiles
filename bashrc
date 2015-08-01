# Colorized prompt
function __ps1() {
    source /usr/lib/git-core/git-sh-prompt

    local RS='\[\033[0m\]'
    local EMW="\[\033[1;37m\]"
    local COLOR=$1
    if [ "$USER" = "root" ]; then
        COLOR="red"
    fi
    case $COLOR in
        "black")
            local EM="\[\033[1;30m\]"
            local BG="\[\033[40m\]"
            local FG="\[\033[30m\]"
            ;;
        "red")
            local EM="\[\033[1;31m\]"
            local BG="\[\033[41m\]"
            local FG="\[\033[31m\]"
            ;;
        "green")
            local EM="\[\033[1;32m\]"
            local BG="\[\033[42m\]"
            local FG="\[\033[32m\]"
            ;;
        "yellow")
            local EM="\[\033[1;33m\]"
            local BG="\[\033[43m\]"
            local FG="\[\033[33m\]"
            ;;
        "blue")
            local EM="\[\033[1;34m\]"
            local BG="\[\033[44m\]"
            local FG="\[\033[34m\]"
            ;;
        "magenta")
            local EM="\[\033[1;35m\]"
            local BG="\[\033[45m\]"
            local FG="\[\033[35m\]"
            ;;
        "cyan")
            local EM="\[\033[1;36m\]"
            local BG="\[\033[46m\]"
            local FG="\[\033[36m\]"
            ;;
        "white")
            local EM="\[\033[1;37m\]"
            local BG="\[\033[47m\]"
            local FG="\[\033[37m\]"
            ;;
    esac
    PS1="$BG$EMW[$BG$EMW\h$BG$EMW]$RS$FG[$EMW\u$FG][$EMW\w$FG][$EMW\$$FG]\$(__git_ps1 \(%s\))$RS "
}

__ps1 "blue"

# tmux
if [[ $TMUX = "" ]]; then
    export TERM="xterm-256color"
else
    export TERM="screen-256color"
fi

# Node.js
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
if which nvm >/dev/null; then
    nvm use 0.12 > /dev/null
fi

# Haskell
export PATH=~/.cabal/bin:$PATH

