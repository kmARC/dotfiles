README
======

### Setting up on a new host

    git clone git@bitbucket.org:kmARC/vim.git ~/.vim
    cd ~/.vim
    git submodule init
    git submodule update --recursive
    ln -s ~/.vim/vimrc ~/.vimrc

### Update a host

    cd ~/.vim
    git pull --recurse-submodules

### Installing new module

Example: vim-fugitive

    cd ~/.vim
    git submodule add git://github.com/tpope/vim-fugitive.git bundle/vim-fugitive
    git commit -m 'Added vim-fugitive'
    git push

### Required software

    # Needed by default
    sudo apt-get install exuberant-ctags
    # Optional for Syntastic
    sudo apt-get install pylint
    sudo apt-get install npm nodejs-legacy
    sudo npm install -g jshint
    # Optional for haskell
    sudo apt-get install cabal-install
    cabal update
    cabal install ghc-mod
    cabal install hasktags

