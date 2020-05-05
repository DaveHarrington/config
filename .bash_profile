
# Get rid of warning in Catalina https://apple.stackexchange.com/questions/371997/suppressing-zsh-verbose-message-in-macos-catalina
export BASH_SILENCE_DEPRECATION_WARNING=1

if [ -r ~/.profile ]; then . ~/.profile; fi
case "$-" in *i*)
  if [ -r ~/.bashrc ]; then . ~/.bashrc;
  fi
esac

if `command -v fortune`; then fortune; fi
