#!/bin/bash
#= printhint_rsync_ssh.sh

cat <<EOF

# use to force remote permissions: --chmod=F644,D755 

rsync -v -rtlz --delete --chmod=F644,D755 -e 'ssh -p SSH_PORT' /LOCAL_DIR/  SSH_USER@SSH_HOST:/REMOTE_DIR/

EOF

#-EOF
