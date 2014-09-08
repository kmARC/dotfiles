execute pathogen#infect()

syntax on
filetype plugin indent on

set mouse=a
set ts=4
set sw=4
set et
set ai
set nu
set nowrap

map <Leader><Tab> :bnext!<CR>
map <Leader><S-Tab> :bprev!<CR>
map <Leader>w :bn!<CR>:bd #<CR>

if has('gui_running')
    set guifont=Ubuntu\ Mono\ 12
    set guioptions-=T
    set guioptions-=L
    set guioptions-=r
endif

"NERDTree
autocmd vimenter * NERDTree
autocmd VimEnter * wincmd p
map <F9> :NERDTreeToggle<CR>

"vim-powerline
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
