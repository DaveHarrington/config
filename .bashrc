# .bashrc

# User specific aliases and functions


if [ -f /home/drh/usr/bin ]; then
  export PATH=/home/drh/usr/bin/:$PATH
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f ~/config/fb_bashrc ]; then
  source ~/config/fb_bashrc
fi

if [ -f ~/.tmux/tmux.completion.bash ]; then
  . ~/.tmux/tmux.completion.bash
fi

if [ -f ~/config/fabric-completion.bash ]; then
  source ~/config/fabric-completion.bash
fi

export PYTHONSTARTUP=~/.pythonrc.py

if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
  source /usr/local/bin/virtualenvwrapper.sh
fi

shopt -s cmdhist
shopt -s checkwinsize # fix long line entry wrapping in bash


export EDITOR=vim
export INPUTRC=~/.inputrc
export IGNOREEOF=1
export HISTFILESIZE=100000

alias df='df -h'
alias du='du -h -c'
alias mkdir='mkdir -p'
alias grep='grep --colour'

# Git alias
alias gst='git status -sb'
alias gls='git branch -r | grep -v "origin\/v"'
alias gtool='git difftool -y -t opendiff'
alias glogbranch='git log --oneline --decorate master..HEAD'
alias gl='git log --graph --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset"'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative" 
alias gdiffbranch='git diff master...HEAD'
alias glost='git fsck --unreachable | grep commit | cut -d\  -f3 | xargs git log --merges --no-walk --grep=WIP'
alias tm='tmux detach || true && tmux attach-session -t main'
alias ackout='ack'
alias ack='ack --ignore-case --pager="less -r"'

alias vimlast='cd `git root` && vim -p `git log -n 1 --format="%H" --name-only | tail -n +3`'
function __vimgit {
    echo "`git log $@ -n 1 --color --since=2month --name-only`"
    FILES=`git log $@ -n 1 --format="%H" --since=2month --name-only | tail -n +3`
    read -p "Open in VIM (y/n)?" choice
    case "$choice" in
        y|Y ) cd `git root` && vim -p `echo "$FILES"`;;
          * ) ;;
    esac
    }
alias vimgit=__vimgit

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
  #echo $code
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

DEFAULT="\[\e[33;0m\]"
GRAY_COLOR="[37;1m"
PINK="\[\e[35;1m\]"
GREEN_COLOR="[32;1m"
CYAN_COLOR="[36;1m"
ORANGE="\[\e[33;1m\]"
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\e[0;32m\]"
LIGHT_PURPLE="\[\033[1;34m\]"
WHITE="\[\033[1;20m\]"
CYAN="\[\e[1;35m\]"

BASEPROMPT="[\A] ${CYAN}\$(virtualenv)${DEFAULT}${HOST}${DEFAULT}:\u \$(lastcommandfailed)${LIGHT_PURPLE}\$(parse_git_branch)${RED}\$(parse_git_stash) ${GREEN}\w${DEFAULT}"
PROMPT="${BASEPROMPT}\n${CYAN}\$ ${DEFAULT}"
export PS1=$PROMPT
