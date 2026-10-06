#!/bin/bash
#= /etc/profile.d/ssh_login_alert.sh

# d260814 https://gemini.google.com/app/ee1061a44979954a
# don't use PAM as it triggers non-CLI sessiens (scp, rsync-over-ssh) -- better use: /etc/profile.d/ssh_login_alert.sh
# https://askubuntu.com/questions/239949/show-a-notification-at-login-using-pam-exec says:
# "When a user logs in interactively, OpenSSH spawns a login shell (like /bin/bash), which automatically executes scripts placed in /etc/profile.d/
# also do:
# > sudo chmod +x /etc/profile.d/ssh_login_alert.sh

# Only execute if this is an SSH session
if [ -n "$SSH_CONNECTION" ]; then

    #: d261006 added to check if SSH login is editor Zed from Mac:
    #
    # 1. Skip if OpenSSH is executing a specific command (e.g., Zed spawning a remote helper)
    if [ -n "$SSH_ORIGINAL_COMMAND" ]; then
        return 0 2>/dev/null || exit 0
    fi
    #
    # 2. Skip if Zed remote server is detected in the process hierarchy or command line
    if grep -q -i "zed" /proc/$PPID/cmdline 2>/dev/null || [[ "$(ps -p $PPID -o comm= 2>/dev/null)" =~ zed ]]; then
        return 0 2>/dev/null || exit 0
    fi
    #
    # 3. Skip if there is no interactive TTY allocated (human logins allocate a TTY)
    if [ -z "$SSH_TTY" ] || ! tty -s 2>/dev/null; then
        return 0 2>/dev/null || exit 0
    fi
    #.

  ADMIN_EMAIL_ADDRESS="john@de-graaff.net"

  # Extract the client IP address from SSH_CONNECTION ("CLIENT_IP CLIENT_PORT SERVER_IP SERVER_PORT")
  REMOTE_IP=$(echo "$SSH_CONNECTION" | awk '{print $1}')
  USER_NAME=$(whoami)
  HOST_NAME=$(hostname)

  ## Perform lookups
  #GEOIP=$(geoiplookup "$REMOTE_IP" 2>/dev/null)
  #RDNS=$(host "$REMOTE_IP" 2>/dev/null | head -n1 | perl -pe 's/^.*domain name pointer (.*?)\./$1/')

  # Regex for RFC1918 Private IPs (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, plus 127.0.0.1)
  RFC1918_REGEX='^(10\.|192\.168\.|172\.(1[6-9]|2[0-9]|3[01])\.|127\.0\.0\.1)'

  if [[ "$REMOTE_IP" =~ $RFC1918_REGEX ]]; then
      GEOIP="Internal / Private Network (RFC1918)"
      RDNS="N/A (Private IP)"
  else
      GEOIP=$(geoiplookup "$REMOTE_IP" 2>/dev/null)
      RDNS=$(host "$REMOTE_IP" 2>/dev/null | head -n1 | perl -pe 's/^.*domain name pointer (.*?)\./$1/')
  fi

  SUBJECT="SSH Interactive Login Alert: $USER_NAME @ $HOST_NAME"
  BODY="User '$USER_NAME' opened an interactive shell from $REMOTE_IP on $(date).\nTTY: $SSH_TTY\nGeoIP: $GEOIP\nReverse-DNS: $RDNS"

  echo -e "$BODY" | mail -s "$SUBJECT" "$ADMIN_EMAIL_ADDRESS"

  # Note: see for mail binary: printhint_msmtp_send_mail_via_STARTTLS.sh 
  # 
  # Note: check if Debian is actually using msmtp as system-wide Mail Transport Agent (MTA) v
  # > ls -l /usr/sbin/sendmail
  # lrwxrwxrwx 1 root root 12 Feb  5  2023 /usr/sbin/sendmail -> ../bin/msmtp

fi

#-eof
