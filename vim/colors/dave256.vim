" Vim color file
" Original Maintainer:  Lars H. Nielsen (dengmao@gmail.com)
" Last Change:  2010-07-23
"
" Modified version of wombat for 256-color terminals by
"   David Liang (bmdavll@gmail.com)
" based on version by
"   Danila Bespalov (danila.bespalov@gmail.com)

set background=dark

if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif

let colors_name = "dave256"


" General colors
hi Normal		ctermfg=252		ctermbg=233		cterm=none		guifg=#e3e0d7	guibg=#242424	gui=none
hi SpecialKey	ctermfg=241		ctermbg=233		cterm=none		guifg=#626262	guibg=#2b2b2b	gui=none
hi LineNr		ctermfg=241		ctermbg=232		cterm=none		guifg=#857b6f	guibg=#080808	gui=none

hi StatusLine	ctermfg=230		ctermbg=237		cterm=none		guifg=#ffffd7	guibg=#444444	gui=italic

if version >= 700
hi ColorColumn					ctermbg=234										guibg=#2d2d2d
endif

hi Cursor		ctermfg=234		ctermbg=228		cterm=none		guifg=#242424	guibg=#eae788	gui=none
hi Visual		ctermfg=253		ctermbg=238		cterm=none		guifg=#c3c6ca	guibg=#554d4b	gui=none
hi VisualNOS	ctermfg=251		ctermbg=236		cterm=none		guifg=#c3c6ca	guibg=#303030	gui=none
hi Search		ctermfg=166  	ctermbg=238		cterm=none		guifg=#d787ff	guibg=#636066	gui=none
hi Title		ctermfg=230						cterm=none		guifg=#ffffd7					gui=bold
hi Folded		ctermfg=103		ctermbg=233		cterm=none		guifg=#a0a8b0	guibg=#3a4046	gui=none
hi StatusLineNC	ctermfg=247		ctermbg=238		cterm=none		guifg=#857b6f	guibg=#444444	gui=none
hi VertSplit	ctermfg=238		ctermbg=238		cterm=none		guifg=#444444	guibg=#444444	gui=none
hi WarningMsg	ctermfg=203										guifg=#ff5f55
hi ErrorMsg		ctermfg=196		ctermbg=236		cterm=bold		guifg=#ff2026	guibg=#3a3a3a	gui=bold

if version >= 700
hi MatchParen	ctermfg=228		ctermbg=101		cterm=bold		guifg=#eae788	guibg=#857b6f	gui=bold

hi Pmenu		ctermfg=230		ctermbg=238						guifg=#ffffd7	guibg=#444444
hi PmenuSel		ctermfg=232		ctermbg=192						guifg=#080808	guibg=#cae982
hi CursorLine					ctermbg=236		cterm=none						guibg=#32322f
endif

" Diff highlighting
hi DiffAdd						ctermbg=17										guibg=#2a0d6a
hi DiffDelete	ctermfg=234		ctermbg=60		cterm=none		guifg=#242424	guibg=#3e3969	gui=none
hi DiffText						ctermbg=52		cterm=none						guibg=#73186e	gui=none
hi DiffChange					ctermbg=237										guibg=#382a37

hi SpellBad term=reverse ctermbg=52 gui=undercurl guisp=Red

"hi CursorIM
"hi Directory
"hi IncSearch
"hi Menu
"hi ModeMsg
"hi MoreMsg
"hi PmenuSbar
"hi PmenuThumb
"hi Question
"hi Scrollbar
"hi SignColumn
"hi SpellBad
"hi SpellCap
"hi SpellLocal
"hi SpellRare
"hi TabLine
"hi TabLineFill
"hi TabLineSel
"hi Tooltip
"hi User1
"hi User9
"hi WildMenu


" Syntax highlighting
hi Keyword		ctermfg=111		cterm=none		guifg=#88b8f6	gui=none
hi Statement	ctermfg=111		cterm=none		guifg=#88b8f6	gui=none
hi Constant		ctermfg=167		cterm=none		guifg=#e5786d	gui=none
hi Number		ctermfg=167		cterm=none		guifg=#e5786d	gui=none
hi PreProc		ctermfg=167		cterm=none		guifg=#e5786d	gui=none
hi Function		ctermfg=227		cterm=none		guifg=#cae982	gui=none
hi Identifier	ctermfg=227		cterm=none		guifg=#cae982	gui=none
hi Type			ctermfg=185		cterm=none		guifg=#d4d987	gui=none
hi Special		ctermfg=229		cterm=none		guifg=#eadead	gui=none
hi String		ctermfg=113  	cterm=none		guifg=#95e454	gui=italic
hi Comment		ctermfg=246		cterm=none		guifg=#9c998e	gui=italic
hi Todo			ctermfg=9		ctermbg=234	cterm=none		guifg=#857b6f	gui=italic


" Links
hi! link FoldColumn		Folded
hi! link CursorColumn	CursorLine
hi! link NonText		LineNr

" vim:set ts=4 sw=4 noet:
