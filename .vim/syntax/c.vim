syn match cType /\<[a-zA-Z_][a-zA-Z_0-9]*_t\>/
syn match cType /\<t_[a-zA-Z_][a-zA-Z_0-9]*\>/
syn keyword cType byte

syn match Namespace /::/

syn keyword cOperator typeof countof ssizeof assert foreach

" global {{{

syn keyword isGlobal  _G
syn match   isGlobal  /\<[a-zA-Z_][a-zA-Z_0-9]*_g\>/

hi def link isGlobal Function
" }}}
