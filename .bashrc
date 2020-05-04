#.bashrc

[[ $- != *i* ]] && return # Short-circuit non-login shells

if [ -f ~/.tmux/tmux.completion.bash ]; then
  . ~/.tmux/tmux.completion.bash
fi

shopt -s cmdhist
shopt -s histappend
shopt -s checkwinsize # fix long line entry wrapping in bash

export EDITOR=vim
export INPUTRC=~/.inputrc
export IGNOREEOF=1
export HISTFILESIZE=100000
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT="%Y.%m.%d %H:%M:%S "
export PROMPT_COMMAND="history -a"

alias df='df -h'
alias du='du -h -c'
alias gist='hub gist create'
alias gistbuffer='tmux save-buffer - | gist'
alias grep='grep --colour'
alias ll='ls -al'
alias mkdir='mkdir -p'
alias wip='git commit -am"wip"'

function ts {
    echo "START" | command ts "[%Y-%m-%d %H:%M:%S]"
    unbuffer "$@" | command ts "[%Y-%m-%d %H:%M:%S]"
    echo "DONE" | command ts "[%Y-%m-%d %H:%M:%S]"
}

function __shortcuts {
  echo "C-b       Back char"
  echo "A-b       Back word"
  echo "C-f       Forward char"
  echo "C-] x     Jump fwd to x"
  echo "A-C-] x   Jump back to x"
  echo "C-y       Paste clipboard"
  echo "A-y       Paste next in kill ring"
  echo "C-_       Undo last change"
  echo "A-r       Undo changes to line"
  echo "C-x C-e   Edit command line in vim"
  echo "A-r       Search this backwards"
}
alias print-shortcuts=__shortcuts

if [ -n "$DISPLAY" -a "$TERM" == "xterm" ]; then
    export TERM="xterm-256color"
fi

export VIRTUAL_ENV_DISABLE_PROMPT=1

function virtualenv() {
  if [ -n "$VIRTUAL_ENV" ]; then
    echo "(`basename \"$VIRTUAL_ENV\"`) "
  fi;
}

function lastcommandfailed() {
  code=$?
  if [ $code != 0 ]; then
    echo -n $'\033[37;1m(exited \033[31;1m'
    echo -n $code
    echo -n $'\033[37;1m) '
  fi
}

function parse_git_dirty {
  status=`git status 2> /dev/null`
  dirty=`    echo -n "${status}" 2> /dev/null | grep -q "Changed but not updated" 2> /dev/null; echo "$?"`
  not_staged=`    echo -n "${status}" 2> /dev/null | grep -q "Changes not staged" 2> /dev/null; echo "$?"`
  staged=`    echo -n "${status}" 2> /dev/null | grep -q "Changes to be committed" 2> /dev/null; echo "$?"`
  untracked=`echo -n "${status}" 2> /dev/null | grep -q "Untracked files" 2> /dev/null; echo "$?"`
  ahead=`    echo -n "${status}" 2> /dev/null | grep -q "Your branch is ahead of" 2> /dev/null; echo "$?"`
  newfile=`  echo -n "${status}" 2> /dev/null | grep -q "new file:" 2> /dev/null; echo "$?"`
  renamed=`  echo -n "${status}" 2> /dev/null | grep -q "renamed:" 2> /dev/null; echo "$?"`
  bits=' '
  if [ "${dirty}" == "0" ]; then
      bits="${bits}[dirty]"
  fi
  if [ "${not_staged}" == "0" ]; then
      bits="${bits}[not staged]"
  fi
  if [ "${staged}" == "0" ]; then
      bits="${bits}[staged]"
  fi
  if [ "${untracked}" == "0" ]; then
    bits="${bits}[untracked]"
  fi
  if [ "${newfile}" == "0" ]; then
    bits="${bits}[new file]"
  fi
  if [ "${ahead}" == "0" ]; then
    bits="${bits}[ahead]"
  fi
  if [ "${renamed}" == "0" ]; then
    bits="${bits}[renamed]"
  fi
  if [ ${#bits} -gt "1" ]; then
    echo "${bits}"
  fi
}

function parse_git_stash {
    return
    branches=$(git branch 2>/dev/null) || return
    ref=$(echo "${branches}" | grep \* | sed 's/* //')
    if [ "${ref}" == "" ]
    then
        ref="(no branch)"
    fi
    vals=$(git stash list 2>/dev/null | grep -n "${ref}:" | perl -n -e'/stash@({.*}):/ && print "$1"') || return
    if [ -n "$vals" ]
    then
      echo "[STASH $vals]"
    fi
}

function parse_git_branch {
    ref=$(git branch 2>/dev/null|grep \*|sed 's/* //') || return
    if [ "$ref" != "" ]
    then
      echo "("${ref}")"
#        echo "("${ref}$(parse_git_dirty)")"
    fi
}

function lastcommandfailed() {
  code=$?
  if [ $code != 0 ]; then
    echo "^^^code $code "
  fi
}

DEFAULT="\[\e[33;0m\]"
BLACK="\[\e[0;30m\]"
DARK_GRAY="\[\e[1;30m\]"
BLUE="\[\e[0;34m\]"
LIGHT_BLUE="\[\e[1;34m\]"
GREEN="\[\e[0;32m\]"
LIGHT_GREEN="\[\e[1;32m\]"
CYAN="\[\e[0;36m\]"
LIGHT_CYAN="\[\e[1;36m\]"
RED="\[\e[0;31m\]"
LIGHT_RED="\[\e[1;31m\]"
PURPLE="\[\e[0;35m\]"
LIGHT_PURPLE="\[\e[1;35m\]"
BROWN="\[\e[0;33m\]"
YELLOW="\[\e[1;33m\]"
LIGHT_GRAY="\[\e[0;37m\]"
WHITE="\[\e[1;37m\]"

if [[ -z "$HOST" ]]; then
  if [[ `hostname` == dharrington-mbp143 ]]; then
    HOST="🐶"
  else
    HOST=`hostname`
  fi
fi

BASEPROMPT="🐶 ${RED}\$(lastcommandfailed)${DARK_GRAY}${HOST} ${DEFAULT}\u ${CYAN}\$(virtualenv)${PURPLE}\$(parse_git_branch)${RED}\$(parse_git_stash) ${GREEN}\w${DEFAULT}"
PROMPT="${BASEPROMPT}\n${CYAN}\\$ ${DEFAULT}"
export PS1=$PROMPT

# Android
export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

