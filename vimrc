execute pathogen#infect()
execute pathogen#helptags()

syntax on
filetype plugin indent on

set modeline
set nocompatible
set mouse=a
set ts=4
set sw=4
set et
set ai
set nu
set nowrap
set ignorecase
set smartcase
set smarttab
set incsearch
set hlsearch
set scrolloff=3
"set colorcolumn=81
set list
set listchars=trail:·,tab:»\ 
set hidden
set cursorline
set t_ut=
set wildmenu

au BufNewFile,BufRead *.html set filetype=htmldjango

map <C-L> :bn!<CR>
map <C-H> :bp!<CR>
map <Leader>w :bp!<CR>:bd #<CR>

if has('gui_running')
    set guifont=Ubuntu\ Mono\ derivative\ Powerline\ 12
    set guioptions-=T
    set guioptions-=L
    set guioptions-=r
endif

"----------
"NERDTree
"----------
autocmd vimenter * wincmd p
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
map <F7> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$']

"----------
"Tagbar
"----------
map <F8> :TagbarToggle<CR>
let g:tagbar_type_haskell = {
    \ 'ctagsbin'  : 'hasktags',
    \ 'ctagsargs' : '-x -c -o-',
    \ 'kinds'     : [
        \  'm:modules:0:1',
        \  'd:data: 0:1',
        \  'd_gadt: data gadt:0:1',
        \  't:type names:0:1',
        \  'nt:new types:0:1',
        \  'c:classes:0:1',
        \  'cons:constructors:1:1',
        \  'c_gadt:constructor gadt:1:1',
        \  'c_a:constructor accessors:1:1',
        \  'ft:function types:1:1',
        \  'fi:function implementations:0:1',
        \  'o:others:0:1'
    \ ],
    \ 'sro'        : '.',
    \ 'kind2scope' : {
        \ 'm' : 'module',
        \ 'c' : 'class',
        \ 'd' : 'data',
        \ 't' : 'type'
    \ },
    \ 'scope2kind' : {
        \ 'module' : 'm',
        \ 'class'  : 'c',
        \ 'data'   : 'd',
        \ 'type'   : 't'
    \ }
\ }

"----------
"vim-powerline
"----------
set laststatus=2
let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

"----------
"vim-molokai
"----------
"let g:molokai_original = 1
let g:rehash256 = 1
colors molokai

"----------
"vim-markdown
"----------
let g:vim_markdown_folding_disabled=1

"----------
"CtrlP.vim
"----------
let g:ctrlp_cmd = 'CtrlPMixed'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc
map <Leader>b :CtrlPBuffer<CR>
map <Leader>. :CtrlPBufTag<CR>
map <Leader>> :CtrlPTag<CR>
let g:ctrlp_buftag_types = {
    \ 'haskell' : {
        \ 'bin': 'hasktags',
        \ 'args': '-x -c -o-',
    \ },
\ }

"----------
"syntastic
"----------
let g:syntastic_auto_loc_list=1
let g:syntastic_always_populate_loc_list=1


"----------
"vim-easytags
"----------
let g:easytags_dynamic_files = 2
let g:easytags_languages = {
    \ 'haskell': {
        \ 'cmd': "hasktags",
        \ 'args': ["-c"],
        \ 'fileoutput_opt': '-f',
        \ 'stdout_opt': '-f-',
        \ 'recurse_flag': ''
    \ }
\ }


set exrc
set secure
