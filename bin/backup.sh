DEST_SERVER="backup.oro.zc2.ibm.com"
DEST_PATH="/var/backups/"
DEST_USER="ubuntu"

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

DEST="rsync://${DEST_USER}@${DEST_SERVER}/${DEST_PATH}"

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

duplicity remove-older-than 6M --force $DEST

duplicity cleanup --force --extra-clean $DEST

duplicity remove-all-inc-of-but-n-full 3 --force $DEST

duplicity collection-status $DEST

echo "======"
echo "    Backup script exiting - $(date)."
echo "======"
