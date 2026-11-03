# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -lh --group-directories-first'
alias la='ll -a'

alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
