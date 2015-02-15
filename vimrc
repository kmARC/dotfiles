call plug#begin('~/.vim/plugged')


Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
Plug 'chriskempson/base16-vim'
Plug 'godlygeek/tabular', { 'on': 'Tabularize'}
Plug 'junegunn/vim-peekaboo'
Plug 'kien/ctrlp.vim'
Plug 'majutsushi/tagbar'
Plug 'plasticboy/vim-markdown'
Plug 'Raimondi/delimitMate'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'Valloric/YouCompleteMe', { 'do': './install.sh' }
Plug 'mattn/emmet-vim',   {'for': 'html'}
Plug 'othree/html5.vim',  {'for': 'html'}
Plug 'groenewege/vim-less',  {'for': 'css'}
Plug 'jelera/vim-javascript-syntax',            {'for': 'javascript'}
Plug 'marijnh/tern_for_vim',                    {'for': 'javascript'}
Plug 'othree/javascript-libraries-syntax.vim',  {'for': 'javascript'}
"Plug 'joonty/vdebug', {'for': 'python'}
"Plug 'xolox/vim-easytags'
"Plug 'jceb/vim-orgmode'
"Plug 'tpope/vim-vinegar'
"Plug 'idanarye/vim-vebugger'
"Plug 'terryma/vim-multiple-cursors'
call plug#end()
runtime macros/matchit.vim

syntax on
filetype plugin indent on

set modeline
set nocompatible
set mouse=a
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>
set ts=4
set sw=4
set et
set ai
set nowrap
set ignorecase
set smartcase
set smarttab
set incsearch
set hlsearch
set scrolloff=3
"set colorcolumn=81
set list
set listchars=trail:·,tab:»\ "
set hidden
set cursorline
set t_ut=
set wildmenu
set backup
set undofile
set directory=~/.vim/vimswap//
set backupdir=~/.vim/vimbackup//
set undodir=~/.vim/vimundo//
let g:netrw_home=expand("~/.vim/misc")
autocmd WinEnter * call UpdateLineNumbering("rnu")
autocmd WinLeave * call UpdateLineNumbering("nornu")
set nu rnu
set path+=**
set laststatus=2
set wildignore+=*.so,*.a,*.swp,*.zip,*.pyc
set timeoutlen=0

function! UpdateLineNumbering(to)
    if &buftype == ""
        execute "set nu " . a:to
    endif
endfunction

set bg=dark
let base16colorspace=256  " Access colors present in 256 colorspace
colors base16-flat
au BufNewFile,BufRead *.html set filetype=htmldjango

map <C-L> :bn!<CR>
map <C-H> :bp!<CR>
map <Leader>w :bp!<CR>:bd #<CR>
map <Leader>f :call Togglefold()<CR>
autocmd bufread *.c,*.cpp map [[ ?{<CR>w99[{
autocmd bufread *.c,*.cpp map ][ /}<CR>b99]}
autocmd bufread *.c,*.cpp map ]] j0[[%/{<CR>
autocmd bufread *.c,*.cpp map [] k$][%?}<CR>
autocmd bufenter *.c,*.cpp nmap <buffer> gd :let varname = '\<<C-R><C-W>\>'<CR>[[^/<C-R>=varname<CR><CR>
autocmd bufenter *.py nmap <buffer> gd :let varname = '\<<C-R><C-W>\>'<CR>?\<def\><CR>/<C-R>=varname<CR><CR>
autocmd bufenter *.js nmap <buffer> gd :TernDef<CR>

function! Togglefold()
    if &l:foldmethod == "manual"
        set foldmethod=syntax
        set foldcolumn=2
    else
        set foldmethod=manual
        set foldcolumn=0
        normal zE
    endif
endfunction

if has('gui_running')
    set guifont=Dejavu\ Sans\ Mono\ for\ Powerline\ 9
    set guioptions-=T
    set guioptions-=L
    set guioptions-=r
    set guioptions-=m
endif


"--- ag.vim ---
nnoremap <Leader>ag :Ag! --<C-R>=expand("%:e")<CR> 
nnoremap <Leader>aG :Ag! --<C-R>=expand("%:e")<CR> <C-R><C-W><CR>

"--- ctrlp.vim ---
let g:ctrlp_cmd = 'CtrlP'
map <Leader>t :CtrlPTag<CR>

"--- delimitMate ---
let delimitMate_expand_cr = 1

"--- nerdtree ---
autocmd vimenter * wincmd p
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
map <F7> :NERDTreeToggle<CR>

"--- syntastic ---
let g:syntastic_auto_loc_list=1
let g:syntastic_always_populate_loc_list=1

"--- tagbar ---
map <F8> :TagbarToggle<CR>

"--- vim-airline ---
let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme='base16'
let g:airline#extensions#whitespace#enabled = 0

"--- vim-markdown ---
let g:vim_markdown_folding_disabled=1

"--- YouCompleteMe ---
let g:ycm_autoclose_preview_window_after_insertion=1

set exrc
set secure
