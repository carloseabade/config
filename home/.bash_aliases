alias maimsclip="maim -s | xclip -selection clipboard -t image/png"

#Add kubectl alias and enable for bash completion
alias k=kubectl
complete -o default -F __start_kubectl k
