# ~/.bashrc: executed by bash(1) for non-login shells.

# General / Global
# ============================

# Avoid duplicates in history
export HISTCONTROL=ignoredups

export PROMPT_COMMAND='history -a'

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"



# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Autocompletion
# ============================

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Alias definitions.
# ============================

if [ -f $HOME/.bash_aliases ]; then
    . $HOME/.bash_aliases
fi

# Custom functions.
# ============================

if [ -f $HOME/.bash_aliases ]; then
    . $HOME/.bash_functions
fi

# SSH Agent.
# ============================

env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add ~/.ssh/id_ed25519
fi

unset env

# CONFIGURE THE PROMPT
# ============================

# Configure `__git_ps1` to tell us as much as possible
export GIT_PS1_SHOWDIRTYSTATE=1 GIT_PS1_SHOWSTASHSTATE=1 GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=verbose GIT_PS1_DESCRIBE_STYLE=branch GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_HIDE_IF_PWD_IGNORED=1

# Colorful prompt for Bash!
export PS1='\[\e[0;36m\][\A] \h:\[\e[0m\e[0;32m\]\W\[\e[1;33m\]$(__git_ps1 " (%s)")\[\e[0;37m\] \$\[\e[0m\] '

# Unrelated but useful: avoid auto-édit on successful merges, starting with Git 2.0
export GIT_MERGE_AUTOEDIT=no
