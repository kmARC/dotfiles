call plug#begin('~/.vim/plugged')
"--- Tools ---
Plug 'christoomey/vim-tmux-navigator'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jpalardy/vim-slime'
Plug 'junegunn/vim-peekaboo'
Plug 'romainl/vim-qf'
Plug 'scrooloose/nerdtree',                     {'on': 'NERDTreeToggle' }
Plug 'tmux-plugins/vim-tmux'
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
Plug 'nanotech/jellybeans.vim'
"--- Git ---
Plug 'airblade/vim-gitgutter'
Plug 'shumphrey/fugitive-gitlab.vim'
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
Plug 'mattn/emmet-vim',                         {'for': ['html', 'htmldjango', 'javascript.jsx']}
Plug 'othree/html5.vim',                        {'for': ['html', 'htmldjango', 'javascript.jsx']}
"--- CSS ---
Plug 'ap/vim-css-color',                        {'for': 'css'}
Plug 'groenewege/vim-less',                     {'for': 'css'}
"--- JavaScript ---
" Plug 'jelera/vim-javascript-syntax',            {'for': ['javascript', 'javascript.jsx']}
Plug 'moll/vim-node'
Plug 'marijnh/tern_for_vim',                    {'for': ['javascript', 'javascript.jsx'], 'do': 'npm install'}
Plug 'mxw/vim-jsx',                             {'for': ['javascript', 'javascript.jsx']}
" Plug 'othree/javascript-libraries-syntax.vim',  {'for': ['javascript', 'javascript.jsx']}
Plug 'othree/yajs.vim',                         {'for': ['javascript', 'javascript.jsx']}
Plug 'pangloss/vim-javascript',                 {'for': ['javascript', 'javascript.jsx']}
"--- C/C++ ---
Plug 'vim-scripts/a.vim',                       {'for': ['cpp', 'c'] }
Plug 'octol/vim-cpp-enhanced-highlight',        {'for': ['cpp', 'c'] }
"--- Haskell ---
Plug 'eagletmt/ghcmod-vim',                     {'for': 'haskell'}
Plug 'eagletmt/neco-ghc',                       {'for': 'haskell'}
Plug 'raichoo/haskell-vim',                     {'for': 'haskell'}
Plug 'Twinside/vim-hoogle',                     {'for': 'haskell'}
"--- todo.txt
Plug 'freitass/todo.txt-vim',                   {'for': 'todo'}
"--- Dependencies
Plug 'Shougo/vimproc.vim',                      {'do':  'make'}     " ghcmod-vim
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
set wildignore+=*.o,*.so,*.a,*.swp,*.zip,*.pyc,tags,.git/*,.env/*
set completeopt=preview
set splitbelow
set splitright

set background=dark
set t_ut=
let base16colorspace=256

if exists('$BASE16_THEME')
    colors base16-$BASE16_THEME
else
    colors base16-default
endif

nnoremap <tab>             :bn<CR>
nnoremap <s-tab>           :bp<CR>
nnoremap <Leader>w         :bp<CR>:bd #<CR>
nnoremap <Leader>W         :bufdo bd<CR>
nnoremap n                 nzz
nnoremap N                 Nzz
nnoremap <Leader>f         :call ToggleFold()<CR>
nnoremap <Leader>ag        :Ag! --<C-R>=expand("%:e")<CR> 
nnoremap <Leader>aG        :Ag! --<C-R>=expand("%:e")<CR> <C-R><C-W><CR>
nnoremap <Leader>pt        :CtrlPTag<CR>
nnoremap <Leader>pb        :CtrlPBuffer<CR>
nmap <leader>1             <Plug>AirlineSelectTab1
nmap <leader>2             <Plug>AirlineSelectTab2
nmap <leader>3             <Plug>AirlineSelectTab3
nmap <leader>4             <Plug>AirlineSelectTab4
nmap <leader>5             <Plug>AirlineSelectTab5
nmap <leader>6             <Plug>AirlineSelectTab6
nmap <leader>7             <Plug>AirlineSelectTab7
nmap <leader>8             <Plug>AirlineSelectTab8
nmap <leader>9             <Plug>AirlineSelectTab9
nnoremap <F7>              :NERDTreeToggle<CR>
nnoremap <F8>              :TagbarToggle<CR>
nnoremap <F9>              :lclose<CR>:cclose<CR>
nnoremap <C-e>   2<C-E>
nnoremap <C-y>   2<C-y>
nnoremap <ScrollWheelUp>   2<C-Y>
nnoremap <ScrollWheelDown> 2<C-E>
autocmd FileType c,cpp              nnoremap <buffer> <Leader>] :YcmCompleter GoTo<CR>
autocmd FileType python             nnoremap <buffer> <Leader>] :YcmCompleter GoTo<CR>
autocmd FileType javascript         nnoremap <buffer> <Leader>] :TernDef<CR>
autocmd FileType javascript.jsx     nnoremap <buffer> <Leader>] :TernDef<CR>
autocmd FileType mkd                nnoremap <buffer> <F8> :Toc<CR>
autocmd FileType vim                nnoremap <F1> :help <C-R><C-W><CR>
autocmd FileType mkd                setlocal tw=80 cc=81
autocmd FileType plaintex,text      setlocal tw=80 cc=81 fo+=awn cc=81
autocmd FileType html               setlocal filetype=htmldjango
autocmd FileType todo               help todo.txt
autocmd FileType javascript setlocal omnifunc=tern#Complete

autocmd BufRead,BufEnter */doc/*    wincmd L | 80 wincmd |
autocmd WinEnter *                  if &buftype == "" | set nu rnu
autocmd WinLeave *                  if &buftype == "" | set nu nornu

function! ToggleFold()
    if &l:foldmethod == "manual"
        set foldmethod=indent foldcolumn=2
    else
        set foldmethod=manual foldcolumn=0
        normal zE
    endif
endfunction

if has('gui_running')
    set guifont=Dejavu\ Sans\ Mono\ for\ Powerline\ 8
    set guioptions=agit
endif

"--- ctrlp.vim ---
let g:ctrlp_working_path_mode = 0
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files -oc --exclude-standard']

"--- delimitMate ---
let delimitMate_expand_cr = 1

"--- fugitive.vim ---
autocmd BufReadPost fugitive://* set bufhidden=delete

"--- fugitive-gitlab.vim ---
let g:fugitive_gitlab_domains = [
    \ 'http://gitlab.zurich.ibm.com'
\ ]

"--- nerdtree ---
autocmd vimenter * wincmd p
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeRespectWildIgnore = 1

"--- netrw ---
let g:netrw_home=expand("~/.vim/misc")

"--- vim-slime ---
let g:slime_target = "tmux"
let g:slime_python_ipython = 1

"--- syntastic ---
let g:syntastic_auto_loc_list=1
let g:syntastic_always_populate_loc_list=1
let g:syntastic_javascript_checkers = ['jsxhint', 'eslint']

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
"let g:Powerline_symbols = 'fancy'
let g:airline_inactive_collapse = 0
let g:airline_powerline_fonts = 1
let g:airline_theme='base16'
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#show_close_button = 1
let g:airline#extensions#whitespace#enabled = 0


"--- vim-markdown ---
let g:vim_markdown_folding_disabled=1

"--- vim-gitgutter ---
let g:gitgutter_max_signs=2000

"--- neco-ghc ---
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

"--- YouCompleteMe ---
" let g:ycm_autoclose_preview_window_after_insertion=1
" let g:ycm_autoclose_preview_window_after_completion=1
let g:EclimCompletionMethod = 'omnifunc'
let g:ycm_semantic_triggers = {'haskell' : ['.']}

"--- UltiSnips ---
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsSnippetDirectories=["plugged/vim-snippets/UltiSnips","UltiSnips"]

set modeline
set exrc
set secure
