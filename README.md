README
======

### Setting up on a new host

    sudo apt-get install git vim tmux
    git clone git@bitbucket.org:kmARC/vim.git ~/.vim
    cd ~/.vim
    git submodule update --init --recursive
    ln -s ~/.vim/vimrc ~/.vimrc
    ln -s ~/.vim/tmux.conf ~/.tmux.conf

### Update a host

    cd ~/.vim
    git pull
    git submodule init
    git submodule update
    git pull --recurse-submodules

### Installing new module

Example: vim-fugitive

    cd ~/.vim
    git submodule add git://github.com/tpope/vim-fugitive.git bundle/vim-fugitive
    git commit -m 'Added vim-fugitive'
    git push

### Required software

    # Needed by default
    sudo apt-get install exuberant-ctags cmake python-dev silversearcher-ag
    cd ~/.vim/bundle/YouCompleteMe
    git submodule update --init --recursive
    ./install.sh
    # Optional for Python
    sudo apt-get install pylint
    # Optional for JavaScript
    sudo apt-get install npm nodejs-legacy
    sudo npm install -g jshint
    # Optional for Haskell
    sudo apt-get install cabal-install
    cabal update
    cabal install ghc-mod
    cabal install hasktags
