# Aliases and functions

alias python='python3'
alias start-lab='jupyter lab --LabApp.token=""'
alias load-workspace='tmux attach -t workspace'

alias automaton="ssh vpacelli@mae-majumdar-lab2.princeton.edu"
alias lambda="ssh vpacelli@128.112.35.85"
alias automaton-foward="ssh -N -f -L localhost:8888:localhost:8888 vpacelli@mae-majumdar-lab2.princeton.edu"

ipy-run () { 
  ipython -c "%run $1"
}

# OS Specific commands.
case `uname` in
  Darwin)
    # commands for MacOS go here
    eval "$(/opt/homebrew/bin/brew shellenv)"
  ;;
  Linux)
    # commands for Linux go here
  ;;
  FreeBSD)
    # commands for FreeBSD go here
  ;;
esac


