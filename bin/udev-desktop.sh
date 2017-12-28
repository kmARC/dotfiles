#!/usr/bin/env bash

su - kmarc -c '(sleep 2; bash -x -c "/home/kmarc/bin/desktop.sh") &'
disown
