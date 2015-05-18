call plug#begin('~/.vim/plugged')
"--- Tools ---
Plug 'christoomey/vim-tmux-navigator'
Plug 'epeli/slimux'
Plug 'junegunn/vim-peekaboo'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree',                     {'on': 'NERDTreeToggle' }
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
"--- Editing ---
Plug 'godlygeek/tabular',                       {'on': 'Tabularize'}
Plug 'Lokaltog/vim-easymotion'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-surround'
Plug 'michaeljsmith/vim-indent-object'
"--- Look&Feel ---
Plug 'bling/vim-airline'
Plug 'chriskempson/base16-vim'
"--- Git ---
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
"--- Programming ---
Plug 'honza/vim-snippets'
Plug 'majutsushi/tagbar'
Plug 'rking/ag.vim'
Plug 'jeetsukumaran/vim-indentwise'
Plug 'scrooloose/syntastic'
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-commentary'
Plug 'Valloric/YouCompleteMe',                  {'do':  './install.sh --clang-completer' }
"--- Markdown ---
Plug 'plasticboy/vim-markdown',                 {'for': 'mkd'}
"--- HTML ---
Plug 'mattn/emmet-vim',                         {'for': 'html'}
Plug 'othree/html5.vim',                        {'for': 'html'}
"--- CSS ---
Plug 'ap/vim-css-color',                        {'for': 'css'}
Plug 'groenewege/vim-less',                     {'for': 'css'}
"--- JavaScript ---
Plug 'jelera/vim-javascript-syntax',            {'for': 'javascript'}
Plug 'marijnh/tern_for_vim',                    {'for': 'javascript', 'do': 'npm install'}
Plug 'othree/javascript-libraries-syntax.vim',  {'for': 'javascript'}
Plug 'pangloss/vim-javascript',                 {'for': 'javascript'}
"--- C/C++ ---
Plug 'vim-scripts/a.vim',                       {'for': ['cpp', 'c'] }
Plug 'octol/vim-cpp-enhanced-highlight',        {'for': ['cpp', 'c'] }
"--- Haskell ---
Plug 'Shougo/vimproc.vim',                      {'do':  'make'}
Plug 'eagletmt/ghcmod-vim',                     {'for': 'haskell'}
Plug 'eagletmt/neco-ghc',                       {'for': 'haskell'}
Plug 'raichoo/haskell-vim',                     {'for': 'haskell'}
Plug 'Twinside/vim-hoogle',                     {'for': 'haskell'}
call plug#end()

runtime macros/matchit.vim

syntax on
filetype plugin indent on

set nocompatible
set mouse=a
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set expandtab
set autoindent
set smartindent
set nowrap
set ignorecase
set smartcase
set incsearch
set hlsearch
set scrolloff=3
set cursorline
set list
set listchars=trail:·,tab:»\ "
set hidden
set wildmenu
set backup
set undofile
set directory=~/.vim/vimswap//
set backupdir=~/.vim/vimbackup//
set undodir=~/.vim/vimundo//
set number relativenumber
set path+=**
set laststatus=2
set wildignore+=*.o,*.so,*.a,*.swp,*.zip,*.pyc,tags
set completeopt-=preview
set clipboard=autoselect,unnamedplus

set background=dark
set t_ut=
let base16colorspace=256
colors base16-flat

nnoremap <Space>           :bn<CR>
nnoremap <Backspace>       :bp<CR>
nnoremap <Leader>w         :bp<CR>:bd #<CR>
nnoremap <Leader>W         :bufdo bd<CR>
nnoremap <Leader>f         :call ToggleFold()<CR>
nnoremap <Leader>ag        :Ag! --<C-R>=expand("%:e")<CR> 
nnoremap <Leader>aG        :Ag! --<C-R>=expand("%:e")<CR> <C-R><C-W><CR>
nnoremap <Leader>pt        :CtrlPTag<CR>
nnoremap <Leader>pb        :CtrlPBuffer<CR>
vnoremap <Leader>ss        :SlimuxREPLSendSelection<CR>
nnoremap <Leader>sl        :SlimuxREPLSendLine<CR>
nnoremap <Leader>sb        :SlimuxREPLSendBuffer<CR>
nnoremap <F7>              :NERDTreeToggle<CR>
nnoremap <F8>              :TagbarToggle<CR>
nnoremap <ScrollWheelUp>   2<C-Y>
nnoremap <ScrollWheelDown> 2<C-E>
autocmd FileType c,cpp              nnoremap <buffer> <Leader>] :YcmCompleter GoTo<CR>
autocmd FileType python             nnoremap <buffer> <Leader>] :YcmCompleter GoTo<CR>
autocmd FileType javascript         nnoremap <buffer> <Leader>] :TernDef<CR>
autocmd FileType mkd                nnoremap <buffer> <F8> :Toc<CR>
autocmd FileType mkd,plaintex,text  setlocal tw=80 fo+=awn cc=81 spell
autocmd FileType html               setlocal filetype=htmldjango

autocmd winenter *                    if &buftype == "" | set nu rnu
autocmd winleave *                    if &buftype == "" | set nu nornu

function! ToggleFold()
    if &l:foldmethod == "manual"
        set foldmethod=indent foldcolumn=2
    else
        set foldmethod=manual foldcolumn=0
        normal zE
    endif
endfunction

if has('gui_running')
    set guifont=Dejavu\ Sans\ Mono\ for\ Powerline\ 9
    set guioptions=agit
endif

"--- ctrlp.vim ---
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

"--- delimitMate ---
let delimitMate_expand_cr = 1

"--- fugitive.vim ---
autocmd BufReadPost fugitive://* set bufhidden=delete

"--- nerdtree ---
autocmd vimenter * wincmd p
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"--- netrw ---
let g:netrw_home=expand("~/.vim/misc")

"--- slimux ---
let g:slimux_select_from_current_window = 1

"--- syntastic ---
let g:syntastic_auto_loc_list=1
let g:syntastic_always_populate_loc_list=1

"--- tagbar ---
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

"--- vim-airline ---
let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme='base16'
let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#tabline#show_close_button = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

"--- vim-markdown ---
let g:vim_markdown_folding_disabled=1

"--- vim-gitgutter ---
let g:gitgutter_max_signs=2000

"--- neco-ghc ---
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

"--- YouCompleteMe ---
let g:ycm_autoclose_preview_window_after_insertion=1
let g:EclimCompletionMethod = 'omnifunc'
let g:ycm_semantic_triggers = {'haskell' : ['.']}

"--- UltiSnips ---
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsSnippetDirectories=["plugged/vim-snippets/UltiSnips","UltiSnips"]

set modeline
set exrc
set secure
