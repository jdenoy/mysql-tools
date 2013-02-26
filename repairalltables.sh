#!/bin/bash
#
#
# v1.0 by Johan Denoyer
# Feb 2nd, 2013

MYSQL_LOGIN='-uADMIN_USER -pYOUR_PASSWORD'
 
for db in $(echo "SHOW DATABASES;" | mysql $MYSQL_LOGIN | grep -v -e "Database" -e "information_schema")
do
        TABLES=$(echo "USE $db; SHOW TABLES;" | mysql $MYSQL_LOGIN |  grep -v Tables_in_)
        echo "Switching to database $db"
        for table in $TABLES
        do
                echo -n " * Repairing table $table ... "
                echo "USE $db; REPAIR TABLE $table" | mysql $MYSQL_LOGIN  >/dev/null
                echo "done."
        done
done