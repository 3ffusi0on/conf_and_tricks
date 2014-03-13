#
# Custom conf file by 3ffusi0on
#

cat ~/TODO

# Variables
export EDITOR=vim

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Alias# {{{
alias ls='ls --color=auto'
alias g='git'
alias vi='vim'
alias ll='ls -l'
alias la='ls -A'
alias 5='python2.7 ~/Documents/my_tester *'
alias l='ls -1 --ignore="*.o"'
alias rm='mkdir -p ~/Trash/$PWD ; mv -t ~/Trash/$PWD'
alias rm_='/bin/rm'
alias son='echo "pavucontrol"'
alias p='ping google.fr'
alias aer='ssh -i .ssh/id_rsa aer@10.18.207.231'
alias cal='cal -m --three'

alias mnt='sudo mount /dev/sdc1 /mnt'

#export CFLAGS="-D LOGS"
unset CFLAGS
# }}}

# Working Specials Key# {{{
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
	function zle-line-init () {
	printf '%s' ${terminfo[smkx]}
    }
    function zle-line-finish () {
	printf '%s' ${terminfo[rmkx]}
     }
     zle -N zle-line-init
     zle -N zle-line-finish
fi
#}}}

#UPDATE TIME
alias up="sudo /usr/sbin/ntpdate ntp-p1.obspm.fr"

autoload -Uz promptinit
promptinit
prompt walters

#COLOR# {{{
RED="%{"$'\033[01;31m'"%}"
GREEN="%{"$'\033[01;32m'"%}"
BLUE="%{"$'\033[01;34m'"%}"
YELLOW="%{"$'\033[01;33m'"%}"
NORM="%{"$'\033[00m'"%}"
#export PS1="${YELLOW}%n@%m${NORM}:${BLUE}%~${NORM}$ "# }}}

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

zstyle ':completion::complete:*' use-cache 1

# Set Historique
export HISTSIZE=1000
export SAVEHIST=1000
export HISTFILE=~/.history
setopt inc_append_history
# ne pas enregistrer plusieurs fois la même commande
setopt hist_ignore_all_dups

#autocd (ex : pour changer de répertoire : /usr/in, pas besoin de cd avant)
setopt autocd
#utilisation de regex dans le shell (ex : cp *.(tar|bz) .)
setopt extendedglob

# git branch display {{{ 
# get_git_dir accepts 0 or 1 arguments (i.e., location) 
# returns location of .git repo 
get_git_dir () 
{ 
    if [ -d .git ]; then # a .git exists, yeah!
	echo .git 
    else 
	git rev-parse --git-dir 2>/dev/null # we are probably in the .git!
    fi 
} 

get_git_branch ()
{
    local g="$(get_git_dir)"
    if [ -n "$g" ]; then
	b="$(git symbolic-ref HEAD 2>/dev/null)"
	if [ "true" = "$(git rev-parse --is-inside-git-dir 2>/dev/null)" ]; then
	    b="GIT_DIR!"
	fi

	printf -- "(${b##refs/heads/}) "
    fi
}


if [ $UID -eq 0 ]; then
    user_color=$fg_bold[red]
else
    user_color=$fg_bold[yellow]
fi

set_prompt () {
    PS1="${YELLOW}%n@PAArch${NORM}:${BLUE}->${NORM} ${RED}$(get_git_branch)${NORM}"
}

function precmd
{
    set_prompt
}
# }}}

autoload -U compinit && compinit

#autocorrection des commandes
#setopt correctall


ulimit -c unlimited

#Ruby PATH
export PATH="$PATH":/home/simon_p/.gem/ruby/2.1.0/bin
