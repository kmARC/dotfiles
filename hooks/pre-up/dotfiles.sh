#!/usr/bin/env bash

(
cd "$HOME/.dotfiles"
git stash
git pull
git stash pop
)
