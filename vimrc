execute pathogen#infect()

syntax on
filetype plugin indent on

set mouse=a
set ts=4
set sw=4
set et
set ai
set nu

map <C-Tab> :bnext<CR>
map <C-S-Tab> :bprev<CR>

if has('gui_running')
    set guifont=Ubuntu\ Mono\ 12
endif

"NERDTree
autocmd vimenter * NERDTree
autocmd VimEnter * wincmd p
map <F9> :NERDTreeToggle<CR>

"vim-powerline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

"vim-solarized
set background=dark
let g:solarized_termcolors=256
colorscheme solarized

