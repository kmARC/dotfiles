README
======

Setting up on a new host
------------------------

### Install prerequisites

    sudo apt-get install git vim
    sudo apt-get install curl build-essential exuberant-ctags cmake ruby \
        python-dev python-unidecode silversearcher-ag

### Set up vim with plugins

    git clone https://kmARC@bitbucket.org/kmARC/vim.git ~/.vim
    vim -c ':PlugInstall' -c ':qa'
    # Ignore error message by pressing enter

At this point,plugins will automatically installed inside vim. After finished, 
you can startup vim with all plugins installed.

### Configure look&feel

Put the following configuration in your `~/.bashrc`.

    export TERM="xterm-256color"

### Configure font

*vim-airline* is configured to use some nice line drawing characters, arrows, 
branch icons, etc. To use these, install a [powerline-enabled terminal 
font](https://github.com/powerline/fonts).


Update a host
-------------

    cd ~/.vim
    git pull
    vim -c ':PlugUpdate'

Programming languages
---------------------
*TODO: These could be written as shell scripts*

Optional fo **Shell scripting***

    apt-get install shellcheck

Optional for **Python**

    sudo apt-get install pylint

Optional for **JavaScript**

    # Install nvm
    curl https://raw.githubusercontent.com/creationix/nvm/v0.24.0/install.sh \
        | bash
    # Install node v0.12
    source ~/.nvm/nvm.sh
    nvm install 0.12
    # Make nvm loaded automatically in bash
    echo "nvm use 0.12 > /dev/null" >> ~/.bashrc

    npm install -g jshint
    npm install -g git://github.com/ramitos/jsctags.git
    cd ~/.vim/plugged/tern_for_vim
    npm install

Optional for **C/C++**

*Unfortunately this needs to be done after each :PlugUpdate if YouCompleteMe 
updated*

For semantic C/C++ completion to work, you'd need to set up a 
`.ycm_extra_conf.py` file. Refer to [this example][1] and [YouCompleteMe][2] 
help.

    sudo apt-get install libclang-3.5-dev

    cd ~/.vim/misc
    mkdir ycm_build
    cd ycm_build
    cmake -G "Unix Makefiles" -DUSE_SYSTEM_LIBCLANG=ON . \
        ~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp
    make ycm_support_libs
    cd ..
    rm -rf ycm_build


Optional for **Haskell**

    sudo apt-get install cabal-install

    cabal update
    cabal install cabal-install
    cabal install ghc-mod
    cabal install hasktags

Optional for **Java**

Java support is usable with [eclim](elim.org). It comes with it's own set of 
installer, daemon etc.

Installing new modules
----------------------

Refer to https://github.com/junegunn/vim-plug

Example: vim-fugitive. Add the following line to vimrc and run :PlugInstall

    Plug 'tpope/vim-fugitive.git'

To persist the change, commit.

    git commit -m 'Added vim-fugitive'
    git push

[1]: 
(https://raw.githubusercontent.com/Valloric/ycmd/master/cpp/ycm/.ycm_extra_conf.py)
[2]: 
(https://github.com/Valloric/YouCompleteMe#c-family-semantic-completion-engine-usage)
