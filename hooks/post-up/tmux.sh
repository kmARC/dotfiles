#!/usr/bin/env bash

DIR_TPM="$HOME/.tmux/plugins/tpm"

if [ ! -d $DIR_TPM ]; then
    echo "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

    echo "Installing Plugins..."
    tmux -c "$DIR_TPM/bin/install_plugins"
else
    echo "Updating Tmux Plugin Manager..."
    (
    cd $DIR_TPM
    git pull
    )

    echo "Updating Plugins..."
    tmux -c "$DIR_TPM/bin/update_plugins all"
fi
