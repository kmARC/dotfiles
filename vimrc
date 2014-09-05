execute pathogen#infect()

syntax on
filetype plugin indent on
set mouse=a
map <C-Tab> :bnext<CR>
map <C-S-Tab> :bprev<CR>

"NERDTree
autocmd vimenter * NERDTree
autocmd VimEnter * wincmd p
map <F9> :NERDTreeToggle<CR>

"vim-powerline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
