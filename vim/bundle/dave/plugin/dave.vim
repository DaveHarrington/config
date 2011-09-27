" Keep functions in one file
" less clutter in .vimrc

" go to defn of tag under the cursor
fun! MatchCaseTag()
    let ic = &ic
    set noic
    try
        exe 'tjump ' . expand('<cword>')
    finally
       let &ic = ic
    endtry
endfun

fun! ReplaceInsert()
    normal lbde
    startinsert
endfun

" Goto def, python aware
function! SplitGotoDefinition()
    let curr_win_num = winnr()
    exe "wincmd j"
    if (curr_win_num != winnr())
      q!
    endif
    exe 20 . "split"
    call RopeGotoDefinition()
    if (v:statusmsg == "Cannot find the definition!")
      z5
    endif
    exe "redraw"
    z
    exe "wincmd k"
endfunction
