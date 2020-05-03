
if [ -r ~/.profile ]; then . ~/.profile; fi
case "$-" in *i*)
  if [ -r ~/.bashrc ]; then . ~/.bashrc;
  fi
esac

if `command -v fortune`; then fortune; fi
