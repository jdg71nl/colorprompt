#= printhint_tiered_retention_backup.sh

cat <<'EOF'

# d261107 jdg https://claude.ai/chat/8c825079-39d1-4c72-9273-26e5c6478983

# from ^^ my plan is to use locally: restic
# https://restic.readthedocs.io/en/stable/index.html

# but so far not done yet ...

# - - - 

# /Users/jdg/colorprompt/bin/luks_encrypted_volume_open-close.sh

for my new LUKS:jvault.img backup I use a simply rsync-over-ssh to jstore2:

read -p "# type RSYNC_PORT: " RSYNC_PORT
read -p "# type RSYNC_USER: " RSYNC_USER
RSYNC_SSH="ssh -p $RSYNC_PORT"
RSYNC_TARGET="jstore.j71.nl"
RSYNC_DIR="/var/backups/jtiered/upload/"
REMOTE="$RSYNC_USER@$RSYNC_TARGET:$RSYNC_DIR"
rsync -v -rtlz -e "$RSYNC_SSH" --inplace --no-whole-file --sparse --progress "$IMG" "$REMOTE"

EOF

#-eof
