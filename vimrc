call plug#begin('~/.vim/plugged')
"--- Tools ---
Plug 'gcmt/taboo.vim'
Plug 'junegunn/fzf'             , {'dir': '~/.fzf', 'frozen': 1 }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'romainl/vim-qf'
Plug 'scrooloose/nerdtree'      , {'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-obsession'
"--- Git ---
Plug 'airblade/vim-gitgutter'
Plug 'mattn/gist-vim'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'tpope/vim-fugitive'
"--- TMUX ---
Plug 'jpalardy/vim-slime'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux'
"--- Filetype helpers ---
Plug 'nblock/vim-dokuwiki'
Plug 'jceb/vim-orgmode'                 , {'for': 'org'}
"--- Editing ---
Plug 'Raimondi/delimitMate'
Plug 'godlygeek/tabular'                , {'on': 'Tabularize'}
Plug 'michaeljsmith/vim-indent-object'
Plug 'tpope/vim-surround'
"--- Look&Feel ---
Plug 'chriskempson/base16-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"--- Programming ---
Plug 'AndrewRadev/splitjoin.vim'
Plug 'SirVer/ultisnips'
Plug 'Valloric/YouCompleteMe'           , {'do':  './install.py --tern-completer'}
Plug 'editorconfig/editorconfig-vim'
Plug 'honza/vim-snippets'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-commentary'
Plug 'w0rp/ale'
"--- Markdown ---
Plug 'plasticboy/vim-markdown'  , {'for': 'markdown'}
Plug 'shime/vim-livedown'       , {'for': 'markdown'}
"--- HTML ---
Plug 'mattn/emmet-vim'          , {'for': ['html', '*jsx']}
Plug 'othree/html5.vim'         , {'for': ['html', '*jsx']}
"--- CSS ---
Plug 'ap/vim-css-color'         , {'for': 'css'}
Plug 'groenewege/vim-less'      , {'for': 'css'}
"--- Dependencies
Plug 'mattn/webapi-vim'
Plug 'tpope/vim-repeat'
"--- JavaScript ---
Plug 'moll/vim-node'                            , {'for': 'javascript*'}
Plug 'heavenshell/vim-jsdoc'                    , {'for': 'javascript*'}
Plug 'othree/yajs.vim'                          , {'for': 'javascript*'}
Plug 'pangloss/vim-javascript'                  , {'for': 'javascript*'}
" Plug 'othree/javascript-libraries-syntax.vim'   , {'for': 'javascript'}
" Plug 'flowtype/vim-flow'
"--- React ---
Plug 'mxw/vim-jsx'                              , {'for': '*.jsx'}
"--- TypeScript ---
Plug 'leafgarland/typescript-vim'               , {'for': 'typescript*'}
"--- DevOps ---
Plug 'hashivim/vim-terraform'                   , {'for': 'terraform'}
Plug 'pearofducks/ansible-vim'                  , {'for': 'ansible*'}
" "--- C/C++ ---
" Plug 'vim-scripts/a.vim'                  , {'for': ['cpp', 'c'] }
" Plug 'octol/vim-cpp-enhanced-highlight'   , {'for': ['cpp', 'c'] }
" Plug 'rdnetto/YCM-Generator'              , {'for': ['cpp', 'c'], 'branch': 'stable'}
" "--- Haskell ---
" Plug 'eagletmt/ghcmod-vim'    , {'for': 'haskell'}
" Plug 'eagletmt/neco-ghc'      , {'for': 'haskell'}
" Plug 'raichoo/haskell-vim'    , {'for': 'haskell'}
" Plug 'Twinside/vim-hoogle'    , {'for': 'haskell'}
call plug#end()

runtime macros/matchit.vim

syntax on
filetype plugin indent on

set nocompatible
set mouse+=a
set ttymouse=xterm2
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set expandtab
set autoindent
set smartindent
set nowrap
set linebreak
set backspace=indent,eol,start
set showbreak=↵
set pastetoggle=<F12>
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
set viminfo+=n~/.vim/misc/viminfo
set number relativenumber
set path+=**
set laststatus=2
set wildignore+=*.o,*.so,*.a,*.swp,*.zip,*.pyc,*.class,tags,.git/**,.env/**
set completeopt=preview,longest,menuone
set splitright
set diffopt+=vertical   " Always vsplit. Helps with fugitive too
set sessionoptions+=tabpages,globals,localoptions
set switchbuf+=usetab
set wildignorecase
set wildmode=list,full
set wildcharm=<C-z>
set grepprg=ag\ --vimgrep\ $*
set foldlevel=0

"--- Look & Feel ----
set background=dark
let base16colorspace=256
silent! source ~/.vimrc_background

"--- Mappings ----
cmap w!!                   w !sudo tee > /dev/null %
nnoremap <C-e>             2<C-e>
nnoremap <C-y>             2<C-y>
nnoremap <C-p>             :Files<CR>
nnoremap <F7>              :NERDTreeFind<CR>
nnoremap <F8>              :TagbarToggle<CR>
nnoremap <F9>              :lclose<CR>:cclose<CR>:pclose<CR>
nnoremap <leader>fa        :call fzf#vim#grep('ag                            --nogroup --column --color "(?=.)"', 1, {'options':'--exact'})<CR>
nnoremap <leader>fA        :call fzf#vim#grep('ag -G <C-r>=expand("%:e")<CR> --nogroup --column --color "(?=.)"', 1, {'options':'--exact --query=<C-r><C-w> +i'})<CR>
nnoremap <leader>ft        :call fzf#vim#tags('',             {'options':'--exact -i'})<CR>
nnoremap <leader>fT        :call fzf#vim#tags('^<C-r><C-w> ', {'options':'--exact +i'})<CR>
nnoremap <leader>fb        :Buffers<CR>
nnoremap <leader>fw        :Windows<CR>
nnoremap <leader>w         :call BufferClose()<CR>
nnoremap <leader>W         :call BufferCloseAll()<CR>
nnoremap <leader>z         :call ToggleFold()<CR>
vnoremap <leader>t,        :Tabularize /,\zs/l0l1<CR>
vnoremap <leader>t:        :Tabularize /:\zs/l0l1<CR>
vnoremap <leader>t=        :Tabularize /=\+/l1c1<CR>
vnoremap <leader>t<Space>  :Tabularize /\S\+/l1l0<CR>
vnoremap <leader>t<bar>    :Tabularize /<bar>\+/l1c1<CR>
nnoremap <leader>1         1gt
nnoremap <leader>2         2gt
nnoremap <leader>3         3gt
nnoremap <leader>4         4gt
nnoremap <leader>5         5gt
nnoremap <leader>6         6gt
nnoremap <leader>7         7gt
nnoremap <leader>8         8gt
nnoremap <leader>9         9gt
nnoremap <leader>0         0gt
nnoremap <ScrollWheelDown> 2<C-E>
nnoremap <ScrollWheelUp>   2<C-Y>
nnoremap <M-ScrollWheelDown> 4zl
nnoremap <M-ScrollWheelUp>   4zh
nnoremap n                 nzz
nnoremap N                 Nzz
nnoremap [h                :GitGutterPrevHunk<CR>
nnoremap ]h                :GitGutterNextHunk<CR>

"--- Autocommands ---
"----- keywordprg
autocmd FileType vim                            setlocal keywordprg=:help
autocmd FileType javascript*,typescript*        let &l:keywordprg=fnamemodify($MYVIMRC, ":h") . "/docsearch.sh"
autocmd FileType css,less,scss                  let &l:keywordprg=fnamemodify($MYVIMRC, ":h") . "/docsearch.sh"
"----- mappings
autocmd FileType markdown                       nnoremap <buffer> <F6> :LivedownToggle<CR>
autocmd FileType markdown                       nnoremap <buffer> <F8> :Toc<CR><C-w>L<C-w>50<bar>:setlocal winfixwidth<CR>
autocmd FileType c,cpp                          nnoremap <buffer> <Leader>] :YcmCompleter GoTo<CR>
autocmd FileType python                         nnoremap <buffer> <Leader>] :YcmCompleter GoTo<CR>
autocmd FileType javascript*,typescript*        nnoremap <buffer> <Leader>] :YcmCompleter GoTo<CR>
"----- formatting
autocmd FileType vim                            setlocal sw=2 sts=2 ts=2
autocmd FileType javascript*,typescript*,json   setlocal sw=2 sts=2 ts=2
autocmd FileType css,less,scss                  setlocal sw=2 sts=2 ts=2
autocmd FileType terraform                      setlocal sw=2 sts=2 ts=2
autocmd FileType plaintex,text,markdown         setlocal tw=80 formatprg=par\ -jw80
"----- filetypes
autocmd BufRead,BufNewFile Vagrantfile          setlocal filetype=ruby
autocmd BufRead,BufNewFile *.tsx                setlocal filetype=typescript.jsx
"----- marks
autocmd BufWrite *.css,*.less,*.scss            normal! mC
autocmd BufWrite *.html                         normal! mH
autocmd BufWrite *.js,*.jsx,*.ts,*.tsx          normal! mJ
autocmd BufWrite *.md                           normal! mM
autocmd BufWrite *.py                           normal! mP
autocmd BufWrite *.sh                           normal! mS
autocmd BufWrite *.vim,vimrc                    normal! mV
"----- buffer/window opts
augroup BgHighlight
  autocmd!
  autocmd WinEnter * if &l:buftype == "" | setlocal nu rnu
  autocmd WinEnter * set cursorline
  autocmd WinEnter * set colorcolumn=81
  autocmd WinLeave * if &l:buftype == "" | setlocal nu nornu
  autocmd WinLeave * set nocursorline
  autocmd WinLeave * set colorcolumn=0
augroup END
autocmd WinEnter *                              call ExitIfNoListedBufsDisplayed()
autocmd FileType nerdtree                       nnoremap <buffer> <F7> :NERDTreeToggle<CR>
autocmd BufWinEnter,WinEnter */doc/*            wincmd L | 80 wincmd | | setlocal winfixwidth
"----- startup
autocmd VimEnter * call CheckProject()

"--- Functions --- {{{
let s:fcw=2
function! ToggleFold()
  if &l:foldcolumn == s:fcw
    normal zR
    let &l:foldcolumn = 0
  else
    let &l:foldcolumn = s:fcw
    let &l:foldlevel = 0
  endif
  if &l:foldmethod == 'manual'
    let &l:foldmethod='indent'
  elseif &l:foldmethod == 'indent'
    let &l:foldmethod='manual'
  endif
endfunction

function! BufferNext()
  if &l:buftype == '' && &l:buflisted
    bn
  endif
endfunction

function! BufferPrev()
  if &l:buftype == '' && &l:buflisted
    bp
  endif
endfunction

function! BufferClose()
  if &l:buftype != '' || ! &l:buflisted
    quit
  elseif len(getbufinfo({'buflisted':1})) == 1
    bd
  else
    bp
    bd #
  endif
endfunction

function! BufferCloseAll()
  bufdo if &l:buftype == '' | call BufferClose() | endif
endfunction

function! ExitIfNoListedBufsDisplayed()
  let wins = 0
  for buf in getbufinfo({'buflisted':1})
    let wins += len(buf.windows)
  endfor
  if wins == 0
    qall
  endif
endfunction

let s:sess = fnamemodify($MYVIMRC, ":h") . '/sessions/' . substitute($PWD, '\/', '%', 'g')

function! Project()
  if filereadable(s:sess)
    exec "source" . fnameescape(s:sess)
  else
    exec "Obsession " . fnameescape(s:sess)
  endif
endfunction

command! Project call Project()

function! CheckProject()
  if filereadable(s:sess)
    let choice = confirm("Project detected. Should we open?", "&Yes\n&No", 1)
    if choice==1
      call Project()
    endif
  endif
endfunction

" }}}

"--- Plugin configurations ---

"--- delimitMate ---
let delimitMate_expand_cr = 0

"--- editorconfig-vim ---
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

"--- flow ---
let g:flow#enable = 0

"--- fugitive.vim ---
autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd BufReadPost *.git/index  set nobuflisted

"--- fugitive-gitlab.vim ---
let g:fugitive_gitlab_domains = [
      \ 'https://gitlab.sec.in.pan-net.eu/',
      \ 'https://gitlab.tools.in.pan-net.eu/'
      \ ]

"--- FZF ---
let g:fzf_files_options = '--exact'
let g:fzf_buffers_jump = 1
let g:fzf_tags_command = '(git ls-files || ag -l) | ctags -L-'

"--- nerdtree ---
let NERDTreeRespectWildIgnore = 1

"--- netrw ---
let g:netrw_home=expand("~/.vim/misc")
let g:netrw_liststyle=3

"--- vim-slime ---
let g:slime_target = "tmux"
let g:slime_python_ipython = 1
let g:slime_paste_file = tempname()

" "--- orgmode ---
" let g:org_heading_shade_leading_stars = 0
" let g:org_indent = 1

"--- tagbar ---
let g:tagbar_autoclose=1
let g:tagbar_autofocus=1

"--- taboo ---
let g:taboo_renamed_tab_format=' [%N] %l%m |'
let g:taboo_tab_format=' [%N] %f%m |'

"--- vim-airline ---
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_theme = 'base16'
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline_inactive_collapse = 0
let g:airline_section_warning = ''
let g:airline_theme_patch_func = 'AirlineThemePatch'
function! AirlineThemePatch(palette)
    for colors in values(a:palette.inactive)
        let colors[3] = 255
    endfor
endfunction
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.linenr = ''

"--- vim-jsdoc ---
let g:jsdoc_enable_es6 = 1

"--- vim-markdown ---
let g:vim_markdown_folding_disabled=1

"--- vim-gitgutter ---
let g:gitgutter_max_signs=2000

"--- vimwiki ---
let g:vimwiki_list = [{'path': '~/Dokumente/', 'syntax': 'markdown', 'ext': '.md', 'automatic_nested_syntaxes': 1, 'auto_toc': 1, 'index': 'Home'}]
let g:vimwiki_folding = 'list'

"--- YouCompleteMe ---
let g:ycm_autoclose_preview_window_after_insertion=1

"--- UltiSnips ---
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsListSnippets="<c-h>"
let g:UltiSnipsSnippetDirectories=["plugged/vim-snippets/UltiSnips","UltiSnips"]

set modeline
set exrc
set secure

" vim: fdm=marker fdl=0 fen
