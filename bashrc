# general

PATH=/usr/local/opt/python/libexec/bin:/usr/local/sbin:/Users/nubela/.cache/rebar3/bin:/Users/nubela/Library/Python/3.6/bin:$PATH

alias ws="cd ~/workspace"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export MARKPATH=$HOME/.marks
function jump {
cd -P $MARKPATH/$1 2> /dev/null || echo "No such mark: $1"
}
function mark {
mkdir -p $MARKPATH; ln -s "$(pwd)" $MARKPATH/$1
}
function unmark {
rm -i $MARKPATH/$1
}
function marks {
\ls -l $MARKPATH | tail -n +2 | sed 's/ / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}

function _jump {
local cur=${COMP_WORDS[COMP_CWORD]}
local marks=$(find $MARKPATH -type l | awk -F '/' '{print $NF}')
COMPREPLY=($(compgen -W '${marks[@]}' -- "$cur"))
return 0
}
complete -o default -o nospace -F _jump jump

# git

alias g="git"
alias ga="git add"
alias gs="git status -sb"
alias gc="git commit"
alias gl="git log --oneline --decorate"
alias gd="git diff"

#ps1
export PS1="[\u@\[\e[31;1m\]\H \[\e[0m\]\w]\$ "

#mark/jump

export MARKPATH=$HOME/.marks
function jump {
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function mark {
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark {
    rm -i "$MARKPATH/$1"
}
function marks {
    ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}
_completemarks() {
  local curw=${COMP_WORDS[COMP_CWORD]}
  local wordlist=$(find $MARKPATH -type l -printf "%f\n")
  COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
  return 0
}

complete -F _completemarks jump unmark

_virtualenv_auto_activate() {
    if [ -e "Pipfile.lock" ]; then
        # Check to see if already activated to avoid redundant activating
        if [ "$VIRTUAL_ENV/bin/python" != "$(which python)" ]; then
            pipenv shell
        fi
    fi
}

export PROMPT_COMMAND=_virtualenv_auto_activate
