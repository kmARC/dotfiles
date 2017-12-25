#!/usr/bin/env bash

set -e

# DEST_LOCAL="/media/kmarc/Passport/Backup/"
# DEST_S3_BUCKET="backup-kmarc"
# DEST_S3_REGION="eu-central-1"
DEST="/media/kmarc/BACKUP/"
EXCLUDES="/tmp/backup_excludes.txt"
LOCK_FILE="/tmp/lock.backup"

cat > "$EXCLUDES" <<EOF
/home/kmarc/.cache
/home/kmarc/.bitcoin/blocks
/home/kmarc/.bitcoin/chainstate
/home/kmarc/.m2
/home/kmarc/.vagrant.d/boxes
/home/kmarc/.vim/vimswap
/home/kmarc/.vim/vimundo
/home/kmarc/.vim/vimbackup
/home/kmarc/Downloads
/home/kmarc/Torrents
/home/kmarc/VirtualBox VMs
**/*.bak
**/*.ova
**/*.pyc
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

touch "$LOCK_FILE"

BORG_PASSPHRASE=$(secret-tool lookup type borg_passphrase)
export BORG_PASSPHRASE

if [ -z "$BORG_PASSPHRASE" ]; then
    echo "No password specified. Check your secrets. Seahorse, secret-tool"
    echo "Exiting."
    exit -1
fi

echo "======"
echo "    Backup script starting @ $(date)"
echo "======"

if [ -f "$DEST"/README ]; then
    borg create --verbose \
                --progress \
                --stats \
                --compression lz4 \
                --exclude-from "$EXCLUDES" \
                "$DEST"::'{now}' \
                "$HOME"

    borg prune --keep-daily 7 \
               --keep-weekly 4 \
               --keep-monthly 12 \
               --keep-yearly 1 \
               "$DEST"

    borg list "$DEST"
fi

# fusermount -u "$DEST"

rm -rf "$LOCK_FILE"

echo "======"
echo "    Backup script exiting @ $(date)."
echo "======"
