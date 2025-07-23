# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# append to the history file, don't overwrite it
shopt -s histappend

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

KERNEL_NAME=$(uname -s)
if [[ "$KERNEL_NAME" == "Linux" ]]; then
  export SYSTEM_OS="Linux"
elif [[ "$KERNEL_NAME" == MINGW* || "$KERNEL_NAME" == MSYS* || "$KERNEL_NAME" == CYGWIN* ]]; then
  export SYSTEM_OS="Windows"
else
  echo "Unknown system: $KERNEL_NAME"
fi

[ -f "$HOME"/.bash_aliases ] && eval "$(SHELL=/bin/sh lesspipe)"

alias ls='ls --color=auto'
alias grep='grep --color=auto'

get_aws_context() {
  profile=$(echo $AWS_PROFILE)
  if [[ -n $profile ]]
  then
    context=$profile
    role=$(echo $AWS_ROLE)
    if [[ -n $role ]]
    then
      context="$profile@$role"
    fi
    sed -e 's/\(.*\)/ [aws:\1]/' <<< "$context"
  fi
}

parse_git_branch() {
  git branch --show-current 2> /dev/null | sed -e 's/\(.*\)/(\1)/'
}

get_k8s_context() {
    context=$(kubectl config view --minify -o json | jq '.contexts[]')
    if [[ -n $context ]]
    then
	context_name=$(jq -r .name <<< $context)
	namespace=$(jq -r .context.namespace <<< $context)
	if [[ $namespace == "null" ]]
	then
	    context="$context_name@default"
	else
	    context="$context_name@$namespace"
	fi
	sed -e 's/\(.*\)/ [k8s:\1]/' <<< "$context"
    fi
}

get_terraform_workspace() {
  workspace=$(terraform workspace show)
  if [[ $workspace != "default" ]]
  then
    sed -e 's/\(.*\)/ [tf:\1]/' <<< "$workspace"
  fi
}

PS1='\[\033[31m\]\u@\h\[\033[37m\]:\[\033[32m\]\W\['
PS1=$PS1'\033[36m\]$(get_aws_context)\['
PS1=$PS1'\033[35m\]$(parse_git_branch)\['
PS1=$PS1'\033[34m\]$(get_k8s_context)\['
PS1=$PS1'\033[33m\]$(get_terraform_workspace)\['
PS1=$PS1'\033[37m\]\n\$ '

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Functions definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_functions, instead of adding them here directly.
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$PATH:~/.local/bin:~/go/bin
export EDITOR=vim
export VISUAL=vim
export PAGER=less
export BROWSER=firefox

shopt -s histappend #Make all sessions append history
export HISTSIZE=10000 #Make history store 10000 commands

source .bash_aliases

source /usr/share/bash-completion/completions/pass-otp

export PATH=$PATH:/home/carlos.abade/Downloads/android-studio/bin:/home/carlos.abade/go/bin

complete -C /usr/local/bin/terragrunt terragrunt

#[ -f ~/.fzf.bash ] && source ~/.fzf.bash

LOWERCASE_CHARACTER_SET="abcdefghijklmnopqrstuvwxyz"
UPPERCASE_CHARACTER_SET="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
NUMBER_CHARACTER_SET="1234567890"
#SPECIAL_CHARACTER_SET="!$%^&*()_+-=,.<>;:@#~[]{}"
SPECIAL_CHARACTER_SET="\$@%#!*~"
export PASSWORD_STORE_CHARACTER_SET=${LOWERCASE_CHARACTER_SET}${UPPERCASE_CHARACTER_SET}${NUMBER_CHARACTER_SET}${SPECIAL_CHARACTER_SET}
#export PASSWORD_STORE_CHARACTER_SET=${LOWERCASE_CHARACTER_SET}${UPPERCASE_CHARACTER_SET}${NUMBER_CHARACTER_SET}

# Disable flow control (XON/XOFF flow control)
stty -ixon

