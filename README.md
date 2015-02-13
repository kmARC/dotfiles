README
======

### Setting up on a new host

    sudo apt-get install git vim
    sudo apt-get install exuberant-ctags cmake python-dev silversearcher-ag
    # OR
    sudo yum install git vim
    sudo yum install ctags cmake python-devel the_silver_searcher

    git clone git@bitbucket.org:kmARC/vim.git ~/.vim
    vim -c ':PlugInstall' -c ':qa'

At this point, plugins will automatically installed inside vim. After finished, you can startup vim with all plugin installed.

### Update a host

    cd ~/.vim
    git pull
    vim -c ':PlugUpdate'

### Installing new module

Refer to https://github.com/junegunn/vim-plug

Example: vim-fugitive. Add the following line to vimrc and run :PlugInstall

    Plug 'tpope/vim-fugitive.git'

To persist the change, commit.

    git commit -m 'Added vim-fugitive'
    git push

### Required software

Optional for *Python*

    sudo apt-get install pylint
    # OR
    sudo yum install pylint

Optional for *JavaScript*

    sudo apt-get install npm nodejs-legacy
    # OR
    sudo yum install npm

    sudo npm install -g jshint
    cd ~/.vim/plugged/tern_for_vim
    npm install

Optional for *Haskell*

    sudo apt-get install cabal-install
    # OR
    sudo yum install cabal-install

    cabal update
    cabal install ghc-mod
    cabal install hasktags

