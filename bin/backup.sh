if [ -z "$PASSPHRASE" ]; then
    echo -n "Enter passphrase: "
    read -s PASSPHRASE
    export PASSPHRASE
    echo
fi

DEST="rsync://ubuntu@backup.oro.zc2.ibm.com//var/backups/"

echo "======"
echo "    Creating backup @ $(date)"
echo "======"
# doing a monthly full backup (1M)
duplicity \
    --full-if-older-than 1M \
    --exclude '**/.git' \
    --exclude '/home/oro/Documents/Google Drive' \
    --exclude '/home/oro/Documents/**/OwnCloud' \
    --include '/home/oro/bin' \
    --include '/home/oro/Documents' \
    --include '/home/oro/lotus' \
    --include '/home/oro/Pictures' \
    --include '/home/oro/SametimeMeetings' \
    --include '/home/oro/SametimeRooms' \
    --include '/home/oro/git' \
    --include '/home/oro/.Skype' \
    --include '/home/oro/.cisco' \
    --include '/home/oro/.config' \
    --include '/home/oro/.mozilla' \
    --include '/home/oro/.shutter' \
    --include '/home/oro/.ssh' \
    --exclude '**' \
    /home/oro/ \
    $DEST

duplicity \
    remove-older-than 6M \
    --force \
    $DEST

duplicity \
    cleanup \
    --force \
    --extra-clean \
    $DEST

echo "======"
echo "    Backup script exiting - $(date)."
echo "======"
