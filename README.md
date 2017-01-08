README
======

Setting up on a new host
------------------------

### Install prerequisites

    sudo apt-get install git vim
    sudo apt-get install curl build-essential cmake \
        python-dev python-unidecode silversearcher-ag


### Set up vim with plugins

    git clone https://github.com/kmARC/vim.git ~/.vim
    vim -c ':PlugInstall' -c ':qa'

At this point, plugins will automatically installed inside vim. After finished, 
you can startup vim with all plugins installed.

### Configure look&feel

My choice of terminal GUI colors is base16. For more information how to set it
up, visit [https://github.com/chriskempson/base16-shell](base16-shell on
GitHub).

Update a host
-------------

    cd ~/.vim
    git pull
    vim -c ':PlugUpdate' -c ':qa'

Programming languages
---------------------
*TODO: These could be written as shell scripts*

Optional fo **Shell scripting***

    sudo apt-get install shellcheck

Optional for **Python**

    sudo apt-get install pylint ipython bpython

Installing new modules
----------------------

Refer to https://github.com/junegunn/vim-plug

Example: vim-fugitive. Add the following line to vimrc and run :PlugInstall

    Plug 'tpope/vim-fugitive.git'

To persist the change, commit.

    git commit -m 'Added vim-fugitive'
    git push
