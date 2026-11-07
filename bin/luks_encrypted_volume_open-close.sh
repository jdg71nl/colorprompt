#!/usr/bin/env bash
#= /Users/jdg/colorprompt/bin/luks_encrypted_volume_open-close.sh
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

# d261107 jdg https://claude.ai/chat/28e84b8e-a2ed-4931-8e2e-953c7210c06b "Encrypted virtual disk CLI tool"

DIR="luks_volumes"

# - - - - - - = = = - - - - - - . 
ONE_TIME_SETUP=$(cat<<'EOF'

# 1. Create the container file (2 GB, sparse so it only uses space as it fills)
cd $HOME
mkdir -pv luks_volumes
#truncate -s 2G $HOME/luks_volumes/jvault.img
truncate -s 64M $HOME/luks_volumes/jvault.img

# 2. Format it as LUKS2 (asks for a passphrase)
sudo cryptsetup luksFormat --type luks2 $HOME/luks_volumes/jvault.img

# 3. Open it and create a filesystem inside
sudo cryptsetup open $HOME/luks_volumes/jvault.img jvault      # → /dev/mapper/jvault
sudo mkfs.ext4 -L jvault /dev/mapper/jvault
sudo cryptsetup close jvault

EOF
)

# - - - - - - = = = - - - - - - . 

# (jdg: copy from Claude)

#!/usr/bin/env bash
# vault.sh — open | close | backup

set -euo pipefail

IMG="$HOME/$DIR/jvault.img"
NAME="jvault"
MNT="/mnt/jvault"
# REMOTE="backup@server:/backups/"

case "${1:-}" in
  open)
    sudo cryptsetup open "$IMG" "$NAME"          # cryptsetup sets up the loop device itself
    sudo mkdir -p "$MNT"
    sudo mount /dev/mapper/"$NAME" "$MNT"
    echo "Mounted at $MNT"
    ;;
  close)
    sync
    sudo umount "$MNT"
    sudo cryptsetup close "$NAME"
    echo "Closed"
    ;;
  backup)
    if [ -e /dev/mapper/"$NAME" ]; then
      echo "Vault is open — close it first" >&2; exit 1
    fi
    # 
    # echo "### Note: 'backup' is not implemented! (exit-1)" ; exit 1
    # rsync -av --inplace --no-whole-file --sparse --progress "$IMG" "$REMOTE"
    #
    # jdg:
    RSYNC_PORT=""
    RSYNC_USER=""
    RSYNC_SSH=""
    read -p "# type RSYNC_PORT: " RSYNC_PORT
    read -p "# type RSYNC_USER: " RSYNC_USER
    #echo "# RSYNC_PORT = '$RSYNC_PORT' "
    #echo "# RSYNC_USER = '$RSYNC_USER' "
    RSYNC_SSH="ssh -p $RSYNC_PORT"
    # below is from: smartdump
    # rsync -v -rtlz --include-from=$INCL_FILE -e "$RSYNC_SSH" / $RSYNC_USER@$RSYNC_TARGET:$RSYNC_DIR/$CLIENT_NAME/
    #
    RSYNC_TARGET="jstore.j71.nl"
    RSYNC_DIR="/var/backups/jtiered/upload/"
    # REMOTE="backup@server:/backups/"
    REMOTE="$RSYNC_USER@$RSYNC_TARGET:$RSYNC_DIR"
    echo "# > rsync -v -rtlz -e \"$RSYNC_SSH\" --inplace --no-whole-file --sparse --progress \"$IMG\" \"$REMOTE\" "
    rsync -v -rtlz -e "$RSYNC_SSH" --inplace --no-whole-file --sparse --progress "$IMG" "$REMOTE"
    # 
    ;;
  *)
    echo "Usage: $0 {open|close|backup}" >&2; exit 1
    ;;
esac

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# - - - - - - = = = - - - - - - . 
#-eof

