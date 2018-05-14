#.bashrc

if [ -z "$PS1" ]; then
  return
fi

#User specific aliases and functions

if [ -d /home/drh/usr ]; then
  export PATH=${HOME}/usr/bin:$PATH
fi

# # Source global definitions
# if [ -f /etc/bashrc ]; then
# 	. /etc/bashrc
# fi

if [ -f ~/config/fb_bashrc.sh ]; then
  source ~/config/fb_bashrc.sh
fi

if [ -f ~/.tmux/tmux.completion.bash ]; then
  . ~/.tmux/tmux.completion.bash
fi

if [ -f ~/config/fabric-completion.bash ]; then
  source ~/config/fabric-completion.bash
fi
