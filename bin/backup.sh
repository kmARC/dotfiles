#!/usr/bin/env bash

# set -e

DEST_S3_BUCKET="$USER-backup-2"
DEST="${DEST:-/run/media/kmarc/Backup/Backup}"
EXCLUDES="/tmp/backup_excludes.txt"
LOCK_FILE="/tmp/lock.backup"

if [ ! -d "$DEST" ]; then
    echo "Destination directory ($DEST) not available."
    echo "Exiting."
    exit -1
fi

if [[ "$1" == "sync" ]]; then
    aws s3 sync "${DEST}" "s3://${DEST_S3_BUCKET}"
    exit 0
fi

cat > "$EXCLUDES" <<EOF
$DEST
$HOME/.cache
$HOME/.bitcoin/blocks
$HOME/.bitcoin/chainstate
$HOME/.m2
$HOME/.npm
$HOME/.nvm
$HOME/.rustup
$HOME/.thumbnails
$HOME/.vagrant.d/boxes
$HOME/.vim/vimswap
$HOME/.vim/vimundo
$HOME/.vim/vimbackup
$HOME/Downloads
$HOME/Torrents
$HOME/VirtualBox VMs
$HOME/vmware
$HOME/.local/share/Trash
$HOME/.local/share/Steam
$HOME/.local/src
**/*.bak
**/*.ova
**/*.pyc
**/.notmuch
**/__pycache__
**/node_modules
**/Cache
**/tmp
EOF

if [ -f "$LOCK_FILE" ]; then
    echo "Lock file exists at $LOCK_FILE."
    echo "Exiting."
    exit -1
fi

# mkdir -p "$DEST"

# goofys --region "$DEST_S3_REGION" "$DEST_S3_BUCKET" "$DEST"

BORG_PASSPHRASE=$(secret-tool lookup type borg_passphrase)
export BORG_PASSPHRASE

if [ -z "$BORG_PASSPHRASE" ]; then
    echo "No password specified. Check your secrets. Seahorse, secret-tool"
    echo "Exiting."
    exit -1
fi

touch "$LOCK_FILE"
echo "======"
echo "    Backup script starting @ $(date) - $HOME => $DEST"
echo "======"

if [ -f "$DEST"/README ]; then
    borg create --verbose \
                --progress \
                --stats \
                --compression auto,lzma \
                --exclude-from "$EXCLUDES" \
                "$DEST"::'{now}' \
                "$HOME"

    borg prune --keep-within 1d \
               --keep-daily 7 \
               --keep-weekly 4 \
               --keep-monthly 12 \
               --keep-yearly 1 \
               --save-space \
               "$DEST"

    borg list "$DEST"
fi

sync

# fusermount -u "$DEST"
rm -rf "$LOCK_FILE"

echo
echo "Sync to s3:"
echo "    aws s3 sync ${DEST} s3://${DEST_S3_BUCKET}"
echo

echo "======"
echo "    Backup script exiting @ $(date)."
echo "======"
