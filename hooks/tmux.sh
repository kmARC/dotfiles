#!/usr/bin/env bash

DIR_TPM="$HOME/.tmux/plugins/tpm"

print_install_help() {
    echo ""
    echo "Setting up tmux:"
    echo "    sudo apt-get install build-essential libncurses5-dev libevent1-dev libncurses5 libevent-1.4"
    echo "    git clone https://github.com/tmux/tmux.git"
    echo "    cd tmux"
    echo "    ./autogen.sh"
    echo "    ./configure"
    echo "    make -j3"
    echo "    sudo make install"
}

if [ ! "$(which tmux)" ]; then
    echo "Tmux is not installed"
    print_install_help
    exit -1
fi

if ! tmux -V | grep -q '2.'; then
    echo "Tmux version is too low."
    print_install_help
    exit -1
fi

if [ ! -d "$DIR_TPM" ]; then
    echo "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

    echo "Installing Plugins..."
    tmux -c "$DIR_TPM/bin/install_plugins"
else
    echo "Updating Tmux Plugin Manager..."
    (
    cd "$DIR_TPM"
    git pull
    )

    echo "Updating Plugins..."
    tmux -c "$DIR_TPM/bin/update_plugins all"
fi
