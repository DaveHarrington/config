
function lastcommandfailed() {
  code=$?
  if [ $code != 0 ]; then
    echo "%{$reset_color%}(exited $fg[red]$code%{$reset_color%}) "
  fi
}

function activevirtualenv() {
  [ "$VIRTUAL_ENV" ] && echo "(`basename $VIRTUAL_ENV`) "
}

function parse_git_stash {
    ref=$(git branch 2>/dev/null|grep \*|sed 's/* //') || return
    if [ "$ref" != "" ]
    then
      vals=$(git stash list | grep -n ${ref}: | perl -n -e'/stash@({.*}):/ && print "$1"') || return
      if [ -n "$vals" ]
      then
        echo "[STASH $vals]"
      fi
    fi
}

bindkey '\e[3~' delete-char
bindkey '^R' history-incremental-search-backward
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

function zle-line-init zle-keymap-select {
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
bindkey -v

VI_MODE_INSERT="%{$fg_bold[red]%}:%{$reset_color%}"
VI_MODE_NORMAL=" "

function vi_mode_prompt() {
  echo "${${KEYMAP/vicmd/$VI_MODE_NORMAL}/(main|viins)/$VI_MODE_INSERT}"
}

zle-keymap-select () {
  # Buggy
  #case $KEYMAP in
    #vicmd) print -n '\ePtmux;\e\e]50;CursorShape=0\7\e\\';;
    #main) print -n '\ePtmux;\e\e]50;CursorShape=1\7\e\\';;
    #viins) print -n '\ePtmux;\e\e]50;CursorShape=1\7\e\\';;
  #esac
  zle reset-prompt
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[blue]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%}) %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$GIT_DIRTY_COLOR%}✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$GIT_CLEAN_COLOR%}✔"
ZSH_THEME_GIT_PROMPT_ADDED="%{$FG[082]%}✚%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$FG[166]%}✹%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[160]%}✖%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[220]%}➜%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[082]%}═%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[190]%}✭%{$reset_color%}"

PROMPT='[%T] $fg[magenta]%m%{$reset_color%}:%n $(lastcommandfailed)%{$fg[yellow]%}$(activevirtualenv)$(git_prompt_info)%{$fg[red]%}$(parse_git_stash)%{$fg[green]%}%~
%{$fg[cyan]%}⇒%{$reset_color%} $(vi_mode_prompt) '
RPS1='${return_code}'
