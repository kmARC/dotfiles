#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
  echo "Usage: $0 (backup|synconly|list|mount|umount|repair)"
  echo "          [-c config] [-d destination] [-p aws profile] [-b s3-bucket]"
  echo "          -s: sync to s3"
  exit
}

check() {
  if [ -f "$LOCK_FILE" ]; then
      >&2 echo "Lock file exists at $LOCK_FILE. Running processes for $0:"
      pgrep -f "$0"
      >&2 echo "Exiting."
      exit 1
  fi

  if [ -z "$BORG_PASSPHRASE" ]; then
      >&2 echo "No password specified. Check your secrets. Seahorse, secret-tool"
      >&2 echo "Exiting."
      exit 1
  fi

  if [ ! -d "$DEST" ]; then
      >&2 echo "Destination directory ($DEST) not available."
      >&2 echo "Exiting."
      exit 1
  fi

  if [ ! -f "$DEST"/README ]; then
      >&2 echo "Destination directory ($DEST) doesn't look like a Borg repository."
      >&2 echo "Initialize first with 'borg init'."
      >&2 echo "Exiting."
      exit 1
  fi
}

backup() {
  # Create excludes file, add larger than 1G files
  printf '%s\n' "${EXCLUDES[@]}" > "$EXCLUDES_FILE"
  (find "$HOME" -type f -size +1G 2>/dev/null || true) >> "$EXCLUDES_FILE"

  touch "$LOCK_FILE"

  echo "======"
  echo "    Backup script starting @ $(date) - $HOME => $DEST"
  echo "======"
  borg break-lock "$DEST"
  borg create     --verbose \
                  --progress \
                  --stats \
                  --compression auto,lzma \
                  --exclude-from "$EXCLUDES_FILE" \
                  "$DEST"::'{now}' \
                  "$HOME"
  sync
  borg prune      --keep-within 1d \
                  --keep-daily 7 \
                  --keep-weekly 4 \
                  --keep-monthly 12 \
                  --keep-yearly 1 \
                  --save-space \
                  --stats \
                  --list \
                  "$DEST"
  borg list       "$DEST"
  echo "======"
  echo "    Backup finished at $(date)."
  echo "======"

  # Sync to s3 if needed
  [ "$SYNC" = true ] && sync_to_s3
}

list() {
  borg list "$DEST"
  borg info "$DEST"
}

mount_repo() {
  MOUNT_DIR=$(mktemp -d /tmp/backup.mount.XXX)
  borg mount "$DEST" "$MOUNT_DIR"
  echo "======"
  echo "    Backup repository mounted at '$MOUNT_DIR'"
  echo "    To unmount:"
  echo "        $0 umount"
  echo "======"
}

umount_repo() {
  echo "======"
  echo "    Backup repositori(es) unmounted:"
  for d in /tmp/backup.mount.*; do
    fusermount -u "$d" &>/dev/null || true
    echo "    - $d"
    rm -rf "$d"
  done
  echo "======"
}

sync_to_s3() {
  mapfile -t CONNS < <(nmcli connection show --active | tail +2 | awk '{print $2}')
  for c in "${CONNS[@]}"; do
    IS_METERED="$(nmcli connection show $c | awk  "/metered/{ print \$2 }")"
    if [ "$IS_METERED" == "yes" ]; then
      echo "Not syncing to S3; Metered connection"
      return 0
    fi
  done

  echo "======"
  echo "    Syncing to s3://$S3_BUCKET"
  echo "======"
  aws --profile "$AWS_PROFILE" s3 sync "$DEST" "s3://$S3_BUCKET"
}

repair() {
  echo "======"
  echo "    Repair '$DEST'"
  echo "======"
  borg check --repair --verbose --progress "$DEST"
  echo "======"
  echo "    Done."
  echo "======"
}

cleanup() {
  rm -f "$LOCK_FILE" "$EXCLUDES_FILE"
}

# Error handling
trap "cleanup" INT TERM HUP EXIT
trap "echo Error in: \${FUNCNAME:-top level}, line \${LINENO}" ERR

##########
#  Main  #
##########

# Save action and shift to the flags
ACTION=${1:-}
[ -n "$ACTION" ] && shift

# Parse configuration
while getopts 'c:d:b:p:s' c; do
  case $c in
    c) CONFFILE=$OPTARG ;;
    s) SYNC=true ;;
    d) _DEST=$OPTARG ;;
    b) _S3_BUCKET=$OPTARG ;;
    p) _AWS_PROFILE=$OPTARG ;;
    *) ;;
  esac
done

# Set configuration
CONFFILE=${CONFFILE:-$HOME/.config/backuprc}
# shellcheck source=/dev/null
source "$CONFFILE" || (>&2 echo "File '$CONFFILE' cannot be opened" && exit 1)
# Override configuration
DEST=${DEST:-$_DEST}
AWS_PROFILE=${AWS_PROFILE:-$_AWS_PROFILE}
S3_BUCKET=${S3_BUCKET:-$_S3_BUCKET}
EXCLUDES=${EXCLUDES:-}
# Opts
SYNC=${SYNC:-false}
# Defaults
EXCLUDES_FILE=$(mktemp /tmp/backup.excludes.XXXXX.txt)
LOCK_FILE="/tmp/backup.lock"

# Check if all configuration needed is properly set
check

# Invoke action
case "$ACTION" in
  'backup')   backup ;;
  'synconly') sync_to_s3 ;;
  'list')     list ;;
  'mount')    mount_repo ;;
  'umount')   umount_repo ;;
  'repair')   repair ;;
  *)          usage ;;
esac
