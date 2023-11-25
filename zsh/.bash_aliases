alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -1 --ignore="*.o"'

alias grep="grep --color=auto"
alias grepp="grep -Hn"

alias cpv='rsync -ah --info=progress2'

# Git
alias gcl="(git branch --merged > /tmp/merged-branches && vi /tmp/merged-branches && xargs git branch -D < /tmp/merged-branches); git remote prune origin; git gc"
alias g='git'
alias gx='git update-index --add --chmod=+x'
alias squash-br='git reset $(git merge-base master $(git rev-parse --abbrev-ref HEAD)) && git add .'
alias wip='git add . && git ci -m WIP'
alias amend='git ci --amend --no-edit'
