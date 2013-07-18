#!/bin/bash
#
#
# v1.0 by Maciej Mensfeld
# Apr 4th, 2013
#
# v1.1 by Johan Denoyer
# Jul 17th, 2013

TIMESTAMP=$(date +"%F")
BACKUP_DIR="/backup/$TIMESTAMP"
MYSQL_USER="backup"
MYSQL_PASSWORD="password"
MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump
 
mkdir -p $BACKUP_DIR

# Lock database
$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "FLUSH TABLES WITH READ LOCK;SET GLOBAL read_only = ON;"

#Backup database
databases=`$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema)"`
 
for db in $databases; do
  $MYSQLDUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $db | gzip > "$BACKUP_DIR/$db.gz"
done
#remove lock
$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SET GLOBAL read_only = OFF;UNLOCK TABLES;"