#!/bin/bash
#= printhint_msmtp_send_mail_via_STARTTLS.sh

cat <<EOF

###: d260814 extra info related to sending email

### add e-mail and relate to Unix users:

> vi /etc/aliases
# See man 5 aliases for format
postmaster:    root
#: d260814 jdg
root: john@de-graaff.net
jdg:  john@de-graaff.net
#-eof

# then:
> sudo newaliases

### replace Postfix:SMTP with msmtp:STARTTLS

# d260814 inspri: https://gemini.google.com/app/ee1061a44979954a
#
# 587 = STARTTLS
# - Initial Connection: The email app connects to the mail server on TCP port 587 in plain text.
# - STARTTLS Command: The app asks the server to switch on safety features.
# - Secure Upgrade: Both sides switch to an encrypted TLS session before sending login details or email data.
# - Authentication: The user provides a verified username and password.
# - Port Comparison
# - Port 587: Uses explicit TLS (STARTTLS); best for general app and client compatibility.
# - Port 465: Uses implicit TLS; encrypts the connection immediately from the start.
# - Port 25: Used for server-to-server relay; often blocked by internet providers to stop spam.
# - Port 2525: A backup port used if firewalls block port 587.
#
# 465 = TLS/SSL 
# - No Plaintext Phase: Unlike port 587 (which uses STARTTLS to upgrade a cleartext connection), port 465 never transmits data in plain text.
# - Naming History: It was originally meant for SMTPS (SMTP over SSL). While briefly deprecated, it remains widely supported and officially used for secure client submission

sudo apt update
sudo apt install msmtp msmtp-mta ca-certificates -y

cat /etc/msmtprc

# Default settings
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        /var/log/msmtp.log
#
# Account details
account        gmail
host           smtp.gmail.com
port           587
from           john@de-graaff.net
user           john@de-graaff.net
password       abcdefghijklmnop
#
# Note: get the "App Password" from the Google Account website
#
# Set default account
account default : gmail

sudo chmod 644 /etc/msmtprc
sudo touch /var/log/msmtp.log
sudo chmod 666 /var/log/msmtp.log

EOF

#-eof

