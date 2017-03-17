#!/usr/bin/env bash

DEST_SERVER=""
DEST_PATH="/var/backups/"
DEST_USER="ubuntu"

DEST="rsync://${DEST_USER}@${DEST_SERVER}/${DEST_PATH}"

ping -c1 ${DEST_SERVER} > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "Destination server (${DEST_SERVER}) currently unreachable"
    exit -1
fi

if [ -z "$PASSPHRASE" ]; then
    echo -n "Enter passphrase: "
    read -s PASSPHRASE
    export PASSPHRASE
    echo
fi

echo "======"
echo "    Creating backup @ $(date)"
echo "======"
# doing a monthly full backup (1M)
duplicity \
    --full-if-older-than 1M \
    --exclude '**/.git' \
    --exclude '~/Documents/Google Drive' \
    --exclude '~/Documents/**/OwnCloud' \
    --include '~/bin' \
    --include '~/Documents' \
    --include '~/lotus' \
    --include '~/Pictures' \
    --include '~/SametimeMeetings' \
    --include '~/SametimeRooms' \
    --include '~/git' \
    --include '~/.Skype' \
    --include '~/.cisco' \
    --include '~/.config' \
    --include '~/.mozilla' \
    --include '~/.shutter' \
    --include '~/.ssh' \
    --exclude '**' \
    $HOME \
    $DEST

duplicity remove-older-than 6M --force $DEST

duplicity cleanup --force --extra-clean $DEST

duplicity remove-all-inc-of-but-n-full 3 --force $DEST

duplicity collection-status $DEST

echo "======"
echo "    Backup script exiting - $(date)."
echo "======"
