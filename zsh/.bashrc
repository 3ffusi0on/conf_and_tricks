alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -1 --ignore="*.o"'
alias grep="grep --color=auto"
alias grepp="grep -Hn"
alias gcl=" git branch --merged >/tmp/merged-branches && vi /tmp/merged-branches && xargs git branch -d </tmp/merged-branches"
alias g='git'
alias gx='git update-index --add --chmod=+x'

export PROMPT_COMMAND='history -a'

# CONFIGURE THE PROMPT
# ============================

# Configure `__git_ps1` to tell us as much as possible
export GIT_PS1_SHOWDIRTYSTATE=1 GIT_PS1_SHOWSTASHSTATE=1 GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=verbose GIT_PS1_DESCRIBE_STYLE=branch GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_HIDE_IF_PWD_IGNORED=1

# Colorful prompt for Bash!
export PS1='\[\e[0;36m\][\A] \h:\[\e[0m\e[0;32m\]\W\[\e[1;33m\]$(__git_ps1 " (%s)")\[\e[0;37m\] \$\[\e[0m\] '
 
# Or if you want the basic prompt, no colors, no timestamps, just regular + Git info:
# export PS1='\h:\W$(__git_ps1 " (%s)")\$ '

# Unrelated but useful: avoid auto-édit on successful merges, starting with Git 2.0
export GIT_MERGE_AUTOEDIT=no
