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

fun! SplitGotoDefinition()
    call 25sp
    call RopeGotoDefinition()
endfun

