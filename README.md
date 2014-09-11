README
======

### Setting up on a new host

    git clone git@bitbucket.org:kmARC/vim.git ~/.vim
    cd ~/.vim
    git submodule init
    git submodule update --recursive
    git pull --recurse-submodules
    ln -s ~/.vim/vimrc ~/.vimrc

### Installing new module

Example: vim-fugitive

    cd ~/.vim
    git submodule add git://github.com/tpope/vim-fugitive.git bundle/vim-fugitive
    git commit -m 'Added vim-fugitive'
    git push

