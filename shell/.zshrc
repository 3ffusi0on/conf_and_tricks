#####
#
# Custom zsh configuration file by 3ffusi0on
#
####

#### Variables# {{{
export EDITOR=vim
export BROWSER=chromium
# }}}

# Alias# {{{
## I'm very lazy
alias g='git'
alias c='cat'

alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -1 --ignore="*.o"'
alias cal='cal -m --three'
alias mnt='sudo mount /dev/sdc1 /mnt'
alias grep="grep --color=auto"
alias grepp="grep -Hn"

## fun
alias mkplay="find -type f -iname \*.mp3 > playlist.txt"
alias play="mplayer -shuffle -playlist playlist.txt"
# }}}

# Working Specials Key# {{{
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

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

##### COLOR# {{{
eval `TERM=xterm-256color dircolors -b`
RED="%{"$'\033[01;31m'"%}"
GREEN="%{"$'\033[01;32m'"%}"
BLUE="%{"$'\033[01;34m'"%}"
YELLOW="%{"$'\033[01;33m'"%}"
NORM="%{"$'\033[00m'"%}"
# }}}

##### Completion# {{{
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
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
# }}}

##### Some stuff# {{{

# Set Historique
export HISTSIZE=1000
export SAVEHIST=1000
export HISTFILE=~/.history
setopt inc_append_history

# Doeas not save the same cmd many times
setopt hist_ignore_all_dups

#autocd (ex : .. same as cd ..)
setopt autocd

#utilisation of regex in shell (ex : cp *.(tar|bz) .)
setopt extendedglob

autoload -U compinit && compinit

ulimit -c unlimited
# }}}

##### Prompt# {{{
autoload -U promptinit
promptinit
setopt promptsubst

# VCS info in the right prompt
autoload -Uz vcs_info

FMT_BRANCH="%F{magenta}%s:%F{blue}%b%B%F{magenta}%u%c%%b%F{default}"
FMT_ACTION="(%F{blue}%a%F{default})"

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr   '^'
zstyle ':vcs_info:*' actionformats "${FMT_BRANCH}${FMT_ACTION} / "
zstyle ':vcs_info:*' formats       "${FMT_BRANCH} / "
zstyle ':vcs_info:*' nvcsformats   ""

unset RPROMPT

PS1="%B" # Bold font
PS1+="%F{yellow}%n"			# Username
PS1+="%F{yellow}@%m"			# Hostname
PS1+="%F{white}:%F{blue}-> "

#Left part of the prompt
PS1+="%F{default}%b" 			# Restore normal font
export PS1

#Rigth aligned part of the prompt
RPS1="%B"
RPS1+='${vcs_info_msg_0_}' 		 # VCS info
RPS1+='%B%F{green}${ps1_path} '		 # Path
RPS1+="%F{default}%b"			 # Restore normal font
export RPS1
setopt transient_rprompt

function precmd {
    # Terminal title
    case $TERM in
	xterm*|rxvt*|Eterm|screen) print -Pn "\e]0;%n@%m: %~\a" ;;
    esac

    # Update VCS prompt (without telling stuff like "fatal: This operation
    # must be run in a work tree" if we are in a .git dir)
    vcs_info 2>/dev/null

    # Path displayed in PS1 - collapse $HOME but not other variables
    ps1_path="${PWD/#$HOME/~}"
    # Collapse each dir(but the last) to its first letter
    # From  http://git.io/ffi9_A, no idea how it works :)
    if [[ ! "${ps1_path}" == "~" ]]; then
	ps1_path="${${${(@j:/:M)${(@s:/:)ps1_path}##.#?}:h}%/}/${ps1_path:t}"
    fi
    export ps1_path
}
# }}}
