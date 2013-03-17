" A function for executing BigGrep from within vim.
" To use it, put 'source ~admin/scripts/vim/biggrep.vim' in your .vimrc.
" Run ':TBGS some_string' to search for a string in www/trunk.
" Similar for TBGR, FBGS, and FBGR.
" Bonus! [TF]BGW will search for the word under the cursor.
"
" Of course, you can press enter on the results to jump to them.
" If pressing Enter in the quickfix list doesn't work for you, add this to your
" .vimrc:
"    au BufReadPost quickfix map <buffer> <Enter> :.cc<CR> 
"
" This works only when your working directory is a descendant of the www or
" fbcode or android root.
"
" @author dreiss

function! BigGrep(query, search)
  let subst = ""
  if exists(':Ggrep')
    let corpus_path = substitute(corpus_path, '\n$', '', '')
    let dirname = resolve(getcwd().corpus_path)

    let use_tbgs = 0
    if match(dirname, "/www/") >= 0
      let subst = "s:^www/:".corpus_path.":"
      let use_tbgs = 1
   elseif match(dirname, "/fbcode/") >= 0
      let subst = "s:^fbcode/:".corpus_path.":"
      let use_tbgs = 1
    elseif match(dirname, "/android/") >= 0
      let subst = "s:^android/:".corpus_path.":"
      let use_tbgs = 1
    endif

    if use_tbgs == 1
      let old_grep = &grepprg
      let old_gfmt = &grepformat

      let &grepprg = a:corpus . "bg" . a:query . " '$*' \\| sed -e '".subst."'"
      let &grepformat = "%f:%l:%c:%m"
      " The GNU Bourne-Again Shell has driven me to this.
      let search = substitute(a:search, "'", "'\"'\"'", "g")
      execute "silent grep! " . search
      redraw!
      copen
      "execute "normal \<c-w>J"

      let &grepprg = old_grep
      let &grepformat = old_gfmt
    else
      execute "silent Ggrep! " . a:search
      redraw!
      copen
    endif
  else
    execute "silent grep! -R" . ' ' . a:search . " ."
    redraw!
    copen
  endif
endfunction

command! TBGW call BigGrep("s", expand("<cword>"))
command! -nargs=1 TBGS call BigGrep("s",<q-args>)
command! -nargs=1 TBGR call BigGrep("r",<q-args>)
