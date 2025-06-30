#!/bin/bash
#= smartback-mysql.sh

# GRANT ALL PRIVILEGES ON *.* TO 'backupuser'@'localhost' IDENTIFIED BY 'my_pwd' WITH GRANT OPTION;
# UPDATE mysql.user SET Password=PASSWORD('my_pwd') WHERE User='backupuser';
# FLUSH PRIVILEGES;

DIR="/var/backups/mysql/"
mkdir -pv $DIR

mysqldump --all-databases -u backupuser --password=my_pwd -c  | gzip -c > $DIR/mysql.backup.sql.gz


