execute pathogen#infect()
execute pathogen#helptags()

syntax on
filetype plugin indent on

set modeline

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
set listchars=trail:·
set hidden
set cursorline

au BufWritePost *.py silent! !find -name '*.py' -exec ctags {} + &
au BufWritePost *.java silent! !find -name '*.java' -exec ctags {} + &
au BufWritePost *.c,*.cpp,*.h silent! !find -name '*.c' -or -name '*.cpp' -or -name '*.h'  -exec ctags {} + &
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
let g:molokai_original = 1
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

"----------
"syntastic
"----------
let g:syntastic_auto_loc_list=1
let g:syntastic_always_populate_loc_list=1
