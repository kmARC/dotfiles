#!/usr/bin/env bash

# DEST_LOCAL="/media/kmarc/Passport/Backup/"
DEST_S3_BUCKET="backup-kmarc"
DEST_S3_REGION="eu-central-1"
DEST_S3_MOUNT="/tmp/backup/"
EXCLUDES="/tmp/backup_excludes.txt"
LOCK_FILE="/tmp/lock.backup"

cat > "$EXCLUDES" <<EOF
/home/kmarc/.cache
/home/kmarc/.m2
/home/kmarc/.vagrant.d/boxes
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

mkdir -p "$DEST_S3_MOUNT"

goofys --region "$DEST_S3_REGION" "$DEST_S3_BUCKET" "$DEST_S3_MOUNT"

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

if [ -f "$DEST_S3_MOUNT"/README ]; then
    borg create --verbose \
                --progress \
                --stats \
                --compression lz4 \
                --exclude-from "$EXCLUDES" \
                "$DEST_S3_MOUNT"::'{now}' \
                "$HOME"

    borg prune --keep-daily 7 \
               --keep-weekly 4 \
               --keep-monthly 12 \
               --keep-yearly 1 \
               "$DEST_S3_MOUNT"

    borg list "$DEST_S3_MOUNT"
fi

fusermount -u "$DEST_S3_MOUNT"

rm -rf "$LOCK_FILE"

echo "======"
echo "    Backup script exiting @ $(date)."
echo "======"
