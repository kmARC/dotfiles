execute pathogen#infect()
execute pathogen#helptags()

syntax on
filetype plugin indent on

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

map <Leader><Tab> :bn<CR>
map <Leader><S-Tab> :bp<CR>
map <Leader>w :bp<CR>:bd #<CR>

if has('gui_running')
    set guifont=Ubuntu\ Mono\ 12
    set guioptions-=T
    set guioptions-=L
    set guioptions-=r
endif

"NERDTree
autocmd vimenter * NERDTree
autocmd vimenter * wincmd p
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
map <F9> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$']


"vim-powerline
set laststatus=2
let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

"vim-solarized
set background=dark
"let g:solarized_termcolors=256
colorscheme solarized

"vim-markdown
let g:vim_markdown_folding_disabled=1

"CtrlP.vim
let g:ctrlp_cmd = 'CtrlPMixed'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc
