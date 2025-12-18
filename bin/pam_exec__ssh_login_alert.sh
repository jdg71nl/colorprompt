#!/bin/bash
#= /usr/local/bin/pam_exec__ssh_login_alert.sh

# d251217-jdg: idea from Gemini

# - - - - - - = = = - - - - - - . 
# install:
# (1)
# > sudo cp -av ~/colorprompt/bin/pam_exec__ssh_login_alert.sh /usr/local/bin/pam_exec__ssh_login_alert.sh
# (2)
# > sudo vi /usr/local/bin/pam_exec__ssh_login_alert.sh
# (edit ADMIN_EMAIL_ADDRESS)
# (2)
# > sudo vi /etc/pam.d/sshd
# (add at bottom:)
# session optional pam_exec.so /usr/local/bin/pam_exec__ssh_login_alert.sh
# (no need to reload PAM or anything)
# (3)
# > sudo apt update && sudo apt install postfix mailutils geoip-bin -y
# - - - - - - = = = - - - - - - . 

ADMIN_EMAIL_ADDRESS="name@host.dom"

# Only send email on session open (login)
if [ "$PAM_TYPE" != "close_session" ]; then
    SUBJECT="SSH Login Alert: $PAM_USER @ $(hostname)"
    #BODY="User $PAM_USER logged in from $PAM_RHOST on $(date)"

    GEOIP=$(geoiplookup $PAM_RHOST)

    #RDNS=$(host $PAM_RHOST | head -n1 | awk -F "domain name pointer " '{print $2}')
    RDNS=$(host $PAM_RHOST | head -n1 | perl -pe 's/^.*domain name pointer (.*?)\.$/$1/')

    BODY="User $PAM_USER logged in from $PAM_RHOST on $(date), GeoIP='$GEOIP', Reverse-DNS='$RDNS' "

    echo "$BODY" | mail -s "$SUBJECT" $ADMIN_EMAIL_ADDRESS
fi

#-eof

