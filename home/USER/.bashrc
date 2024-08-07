#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

parse_git_branch() {
  git branch --show-current 2> /dev/null | sed -e 's/\(.*\)/(\1)/'
}

PS1='\[\033[31m\]\u@\h\[\033[37m\]:\[\033[32m\]\w\[\033[35m\]$(parse_git_branch)\[\033[37m\]\$ '

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
