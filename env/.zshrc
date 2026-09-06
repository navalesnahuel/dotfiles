source "$HOME/.zsh_profile"

export MANWIDTH=$(tput cols)
export MANPAGER="less -S -j.5 -FX"
export LESS='-R'

HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS
setopt SHARE_HISTORY INC_APPEND_HISTORY
setopt IGNORE_EOF

fpath=("$HOME/.zsh/completions" $fpath)
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload -Uz compinit
if [[ -f ~/.zcompdump && $(find ~/.zcompdump -mtime +1 2>/dev/null) ]]; then
    compinit
else
    compinit -C
fi

bindkey -e

bindkey -s '^f' "tmux-sessionizer\n"

bindkey '^[b' backward-word
bindkey '^[w' forward-word

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias vim="nvim"
alias ls='eza'
alias l='eza -l'
alias la='eza -la'
alias lt='eza --tree'
alias cat="bat"
alias rg='rg --no-ignore'
alias cd="z"

parse_git_branch() {
    git symbolic-ref --short HEAD 2>/dev/null | sed 's/.*/ &/'
}

precmd() {
    local exit_code=$?
    local DIR=$'%{\033[38;2;191;214;216m%}'
    local BRANCH=$'%{\033[38;2;139;156;159m%}'
    local SUCCESS=$'%{\033[38;2;165;233;245m%}'
    local ERROR=$'%{\033[38;2;224;97;122m%}'
    local GREY=$'%{\033[38;2;180;180;180m%}'
    local RESET=$'%{\033[0m%}'

    local arrow_color
    [[ $exit_code -eq 0 ]] && arrow_color=$SUCCESS || arrow_color=$ERROR

    local branch
    branch=$(parse_git_branch)

    PS1="${DIR}%1~${BRANCH}${branch}${arrow_color} ›${GREY} ${RESET}"
    PS2=$'%{\033[38;2;180;150;80m%}continue %{\033[0m%}%{\033[1m%}> '
}

[[ -f "$HOME/.config/fzf/config.zsh" ]] && source "$HOME/.config/fzf/config.zsh"
eval "$(zoxide init zsh)"
