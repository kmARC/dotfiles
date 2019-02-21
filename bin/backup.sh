#!/usr/bin/env bash
set -euo pipefail

DEST_S3_BUCKET="$USER-backup-2"
DEST="${DEST:-/run/media/kmarc/Backup/Backup}"
EXCLUDES="/tmp/backup_excludes.txt"
LOCK_FILE="/tmp/lock.backup"

if [ ! -d "$DEST" ]; then
    >&2 echo "Destination directory ($DEST) not available."
    >&2 echo "Exiting."
    exit 255
fi

if [[ $# -gt 0 && "$1" == "synconly" ]]; then
    aws --profile s3-backup s3 sync "${DEST}" "s3://${DEST_S3_BUCKET}"
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
$HOME/.tor-browser
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
    >&2 echo "Lock file exists at $LOCK_FILE. Running processes for $0:"
    ps aux | grep "$0"
    >&2 echo "Exiting."
    exit 255
fi

BORG_PASSPHRASE=$(secret-tool lookup type borg_passphrase)
export BORG_PASSPHRASE

if [ -z "$BORG_PASSPHRASE" ]; then
    >&2 echo "No password specified. Check your secrets. Seahorse, secret-tool"
    >&2 echo "Exiting."
    exit 255
fi

function cleanup {
  rm -f "$LOCK_FILE" "$EXCLUDES";
  exit $?
}

touch "$LOCK_FILE"
trap cleanup TERM EXIT

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

echo
if [[ $# -gt 0 && "$1" == "sync" ]]; then
    echo "======"
    echo "    Syncing to s3://${DEST_S3_BUCKET}"
    echo "======"
    aws --profile s3-backup s3 sync "${DEST}" "s3://${DEST_S3_BUCKET}"
else
    echo "To sync to s3:"
    echo "    $0 synconly"
fi
echo
echo "======"
echo "    Backup script exiting @ $(date)."
echo "======"
