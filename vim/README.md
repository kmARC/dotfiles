README
======

Setting up on a new host
------------------------

### Install prerequisites

    sudo apt -y install git vim
    sudo apt -y install curl build-essential cmake python-dev python3-dev \
                        python-unidecode silversearcher-ag nodejs-legacy \
                        npm par

### Set up vim with plugins

    git clone https://github.com/kmARC/vim.git ~/.vim
    vim -c ':PlugInstall' -c ':qa!'

Update a host
-------------

    cd ~/.vim
    git pull
    vim -c ':PlugUpdate' -c ':qa'

Programming languages
---------------------

Optional fo **Shell scripting**

    sudo apt install shellcheck

Optional for **Python**

    sudo apt install pylint ipython bpython
    sudo -H pip install jedi

Optional for **Ansible/yaml**

    sudo -H pip install ansible-lint yamllint

Optional for **Markdown**

    sudo -H npm install -g livedown

Installing new modules
----------------------

Refer to https://github.com/junegunn/vim-plug

