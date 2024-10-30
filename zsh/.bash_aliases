if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grepp="grep -Hn"
alias gcl=" git branch --merged >/tmp/merged-branches && vi /tmp/merged-branches && xargs git branch -d </tmp/merged-branches"
alias g='git'
alias gx='git update-index --add --chmod=+x'

alias cpv='rsync -ah --info=progress2'
alias reload='echo "Reloading shell...";exec env -i HOME=$HOME bash -l'

# Git
alias gcl="(git branch --merged > /tmp/merged-branches && vi /tmp/merged-branches && xargs git branch -D < /tmp/merged-branches); git remote prune origin; git gc"
alias g='git'
alias gx='git update-index --add --chmod=+x'
alias squash-br='git reset $(git merge-base master $(git rev-parse --abbrev-ref HEAD)) && git add .'
alias wip='git add . && git ci -m WIP'
alias amend='git ci --amend --no-edit'
