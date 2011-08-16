" change the mapleader from \ to ,
let mapleader=","

filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
filetype plugin indent on
set wildmode=longest,list,full
:set wildmenu
:set nu 
":set smartindent
:set showmatch
set mat=5
:set ai
:set ts=4
:set sw=4 " treat 4 spaces as a tab when deleting4
:set sts=4 " treat 4 spaces as a tab when deleting
:set expandtab " insert spaces instead of \t
:syntax on
:set backspace=start,indent,eol
:set wrapscan
:set t_Co=256
:colo gardener
:set hidden
:set switchbuf=usetab,newtab " use an existing tab if one exists for a file, otherwise create a new one
set path+=$PWD/**
"
" gvim ctrl-c/v support
nmap <C-V> "+gP
imap <C-V> <ESC><C-V>i
vmap <C-C> "+y

" ctrl tab to change tabs
noremap <c-tab> :tabnext<cr>
noremap <c-s-tab> :tabprev<cr>

" Set to auto read when a file is changed from the outside
set autoread

set nobackup
set nowb
set noswapfile

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

if has("gui_running")
  if has("mac")
    set guifont=Menlo:h15
  endif
  color desert
endif

python << EOF
import os
import sys
import vim
for p in sys.path:
	if os.path.isdir(p):
		vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
EOF

map <silent><C-Left> <C-T>
map <silent><C-Right> <C-]>
autocmd FileType python set omnifunc=pythoncomplete#Complete
inoremap <Nul> <C-x><C-o>

autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

au FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
" You might also find this useful
" PHP Generated Code Highlights (HTML & SQL)                                              
  
let php_sql_query=1                                                                                        
let php_htmlInStrings=1

" Folding
" http://smartic.us/2009/04/06/code-folding-in-vim/
"set foldmethod=indent
"set foldnestmax=10
"set foldlevel=1
"set foldnestmax=2

" CTags config
let Tlist_Compact_Format = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Ctags_Cmd = "ctags"
let Tlist_WinWidth = 40
map <F4> :TlistToggle<cr>
map <F6> :NERDTreeToggle<cr>
map <F8> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
" More ctags stuff: http://amix.dk/blog/post/19329 
" Generate ctags data for a PHP project: ctags-exuberant -f ~/.vim/mytags/mendeley -h ".php" -R --totals=yes --tag-relative=yes --PHP-kinds=+cf --regex-PHP='/abstract class ([^ ]*)/\1/c/' --regex-PHP='/interface ([^ ]*)/\1/c/' --regex-PHP='/(public |static |abstract |protected |private )+function ([^ (]*)/\2/f/'
"

"Dave's settings
inoremap <C-j> <ESC>
nnoremap ; :

"Scroll through long lines properly
nnoremap j gj
nnoremap k gk

"Clear highlights with ,/
nmap <silent> ,/ :nohlsearch<CR>

"Save file with sudo if you forgot with w!!
cmap w!! w !sudo tee % >/dev/null

"No arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

"Keep backups seperate
silent execute '!mkdir -p ~/.vim_backups'
set backupdir=~/.vim_backups//
set directory=~/.vim_backups//

"Open a window with shortcuts
belowright 37vsplit ~/config/vim_shortcuts.txt

