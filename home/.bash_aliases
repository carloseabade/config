# Git
alias ga="git add"
alias gc="git-commit"
alias gd="git diff"
alias gf="git fetch"
alias gr="git restore"
alias grb="git rebase"
alias grv="git revert"
alias gs="git status"
alias gsh="git show"
alias gpl="git pull"
alias gps="git-push"
alias gpsf="git-push-force"
alias gl="git log --oneline --graph"

# Vim
alias nvim="vim"
alias notes="nvim /d/Users/o-eduard/Documents/tasks/tasks"
alias journal="nvim /d/Users/o-eduard/Documents/tasks/journal"

# Directories
alias dox="cd ~/Documents"
alias dl="cd ~/Downloads"
alias tasks="cd ~/obj/tasks"
alias repos="cd ~/repos/obj"

# Others
alias tf="terraform"
alias bat="bat -S"
alias grep="grep --color=auto"
alias clip='xclip -selection clipboard'
alias f='grep --exclude-dir=.* -rni'
alias folder='nautilus'
alias table='python -c "import sys,prettytable; table=prettytable.from_csv(sys.stdin); table.align=\"l\"; print(table)"'
alias mpv='mpv --autofit=500 --sub-shadow-color=0/0/0 --sub-shadow-offset=1 --sub-font-size=32 --sub-color=0.80/0.75/0.55/1.0 --sub-border-size=0 --sub-margin-y=100 --sub-font="TradeGothic LT Bold"'

alias maimsclip="maim -s | xclip -selection clipboard -t image/png"

alias k=kubectl
complete -o default -F __start_kubectl k
alias kctx='kubectl config use-context'
alias kns='kubectl config set-context --current --namespace'
