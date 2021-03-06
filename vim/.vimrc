"
" Vars
"
"
" General
"
set nocompatible		" no vi-compatible mode
filetype on			" detect the type of the file
filetype plugin on		" load filetypes plugin
set history=500			" history
set cf				" enable error files and erro jumping

"
" Theme
"
syntax on			" enable syntax highlighting
colorscheme desert		" theme: snp

"
" Backup
"
set makeef=error.err		" error files

"
" Vim UI
"
set lsp=0
set wildmenu			" display list for completion mode
set ruler			" display cursor position
set cmdheight=2			" command line uses 2 screen line
"set number			" display line numbers
set lz				" do not redraw while running macro
set showcmd			" display the current command
set backspace=indent,eol,start	" enable a nice backspace
set wildchar=<Tab>
set whichwrap=<,>,[,],b,s,h,l	" enable keys to move cursor
"set mouse=a			" enable mouse uses everywhere
set shortmess=atI		" shortens messages
set report=0			" report anything
set noerrorbells		" no beep

"
" Visual
"
set showmatch			" show matching brackets
set mat=5			" show matching brackets for 5 tenth of secs
set hls
"set nohlsearch			" no highlight for searched phrases
set incsearch			" display matching pattern as typing
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<,eol:$ " :set list
"set so=5			" keep 10 lines for scope
set novisualbell		" do not blink

"
" Text formatting
"
"set fo=tcrqn
set autoindent			" autoindent
"set smartindent			" smartindent
"set cindent			" c-style indenting
set shiftwidth=4
set shiftround
set expandtab
set tabstop=4


"set nowrap
"set smarttab
set ic

"
" Folding : {{{ and }}} syntax
"

set foldmethod=marker
" set foldenable			" enable folding
" set foldmethod=indent
" set foldlevel=0
" set foldopen-=search
" set foldopen-=undo

"
" Misc
"
set wig=*.o
let c_space_errors=1

"
" Autocmd
"
if has("autocmd")
  " jump to the last known cursor position
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \	exe "normal g`\"" |
    \ endif
endif

au BufNewFile,BufRead *.doxygen setfiletype doxygen

"set laststatus=2
"if version >= 700
"   au InsertEnter * hi StatusLine term=reverse ctermbg=5 gui=undercurl
"guisp=Magenta
"   au InsertLeave * hi StatusLine term=reverse ctermfg=0 ctermbg=2
"gui=bold,reverse
"endif
set encoding=utf-8
set fileencoding=utf-8

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" insert 1 character (Space key)
noremap <silent> <space> :exe "normal i".nr2char(getchar())<CR>


" additionals functions
if filereadable($HOME."/.vimconfig/vimrc.function")
   source $HOME/.vimconfig/vimrc.function
endif
