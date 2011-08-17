" change the mapleader from \ to ,
let mapleader=","

" Include vim config
if filereadable(expand("~/.vimrc.janus"))
  source ~/.vimrc.janus
endif
