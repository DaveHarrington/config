# Path to your oh-my-zsh configuration.
ZSH=$HOME/config/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="dave"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git brew django git-flow github osx python pip redis-cli ssh-agent fabric)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# virtualenvwrapper and pip
if [ `id -u` != '0' ]; then
  export VIRTUALENV_USE_DISTRIBUTE=1
  export WORKON_HOME=$HOME/.virtualenvs
  export PIP_VIRTUALENV_BASE=$WORKON_HOME
  export PIP_REQUIRE_VIRTUALENV=true
  export PIP_RESPECT_VIRTUALENV=true
  export VIRTUAL_ENV_DISABLE_PROMPT=1
  if [ -e "/usr/local/bin/virtualenvwrapper.sh" ]; then
    source /usr/local/bin/virtualenvwrapper.sh
  fi
fi
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true
